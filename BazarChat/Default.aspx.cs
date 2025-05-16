using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using BazarChat.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;

namespace BazarChat
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static AuthStatus CheckAuthStatus()
        {
            var user = HttpContext.Current.User;
            if (user.Identity.IsAuthenticated)
            {
                return new AuthStatus
                {
                    IsAuthenticated = true,
                    User = new UserInfo
                    {
                        Email = user.Identity.GetUserName(),
                        FullName = user.Identity.Name
                    }
                };
            }
            return new AuthStatus { IsAuthenticated = false };
        }

        [WebMethod]
        public static List<ChatInfo> GetChats(string filter)
        {
            var chats = new List<ChatInfo>();
            var userId = HttpContext.Current.User.Identity.GetUserId();

            using (var connection = new SqlConnection(GetConnectionString()))
            {
                var query = @"SELECT DISTINCT c.Id, c.Name, c.IsPublic, c.Description, c.CreatedAt, c.ShareLink,
                     (SELECT TOP 1 Text FROM Messages WHERE ChatId = c.Id ORDER BY SentAt DESC) AS LastMessage,
                     (SELECT TOP 1 SentAt FROM Messages WHERE ChatId = c.Id ORDER BY SentAt DESC) AS LastMessageTime
                     FROM Chats c
                     LEFT JOIN UserChats uc ON c.Id = uc.ChatId
                     WHERE (@filter = 'all' OR 
                            (@filter = 'public' AND c.IsPublic = 1) OR 
                            (@filter = 'private' AND c.IsPublic = 0))
                     AND (c.IsPublic = 1 OR uc.UserId = @userId OR c.CreatorId = @userId)
                     ORDER BY LastMessageTime DESC, c.CreatedAt DESC";

                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@filter", filter);
                    command.Parameters.AddWithValue("@userId", userId ?? (object)DBNull.Value);
                    connection.Open();

                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            chats.Add(new ChatInfo
                            {
                                Id = reader["Id"].ToString(),
                                Name = reader["Name"].ToString(),
                                IsPublic = (bool)reader["IsPublic"],
                                Description = reader["Description"].ToString(),
                                LastMessage = reader["LastMessage"] as string,
                                LastMessageTime = reader["LastMessageTime"] as DateTime?,
                                CreatedAt = (DateTime)reader["CreatedAt"],
                                ShareLink = reader["ShareLink"] as string
                            });
                        }
                    }
                }
            }

            return chats;
        }

        [WebMethod]
        public static List<MessageInfo> GetChatMessages(string chatId)
        {
            var messages = new List<MessageInfo>();
            var userId = HttpContext.Current.User.Identity.GetUserId();

            using (var connection = new SqlConnection(GetConnectionString()))
            {
                var query = @"SELECT m.Id, m.Text, m.SentAt, u.UserName, u.Id AS UserId
                             FROM Messages m
                             JOIN AspNetUsers u ON m.UserId = u.Id
                             WHERE m.ChatId = @chatId
                             ORDER BY m.SentAt";

                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@chatId", chatId);
                    connection.Open();

                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            messages.Add(new MessageInfo
                            {
                                Id = reader["Id"].ToString(),
                                Text = reader["Text"].ToString(),
                                SentAt = (DateTime)reader["SentAt"],
                                UserName = reader["UserName"].ToString(),
                                IsCurrentUser = reader["UserId"].ToString() == userId
                            });
                        }
                    }
                }
            }

            return messages;
        }

        [WebMethod]
        public static PlatformStatistics GetPlatformStatistics()
        {
            var stats = new PlatformStatistics();

            using (var connection = new SqlConnection(GetConnectionString()))
            {
                connection.Open();

                // Count total chats
                using (var command = new SqlCommand("SELECT COUNT(*) FROM Chats", connection))
                {
                    stats.TotalChats = (int)command.ExecuteScalar();
                }

                // Count public chats
                using (var command = new SqlCommand("SELECT COUNT(*) FROM Chats WHERE IsPublic = 1", connection))
                {
                    stats.PublicChats = (int)command.ExecuteScalar();
                }

                // Count private chats
                using (var command = new SqlCommand("SELECT COUNT(*) FROM Chats WHERE IsPublic = 0", connection))
                {
                    stats.PrivateChats = (int)command.ExecuteScalar();
                }

                // Count total messages
                using (var command = new SqlCommand("SELECT COUNT(*) FROM Messages", connection))
                {
                    stats.TotalMessages = (int)command.ExecuteScalar();
                }
            }

            return stats;
        }

        [WebMethod]
        public static ChatInfo GetChatInfo(string chatId)
        {
            using (var connection = new SqlConnection(GetConnectionString()))
            {
                var query = "SELECT Id, Name, IsPublic, Description, Codeword, ShareLink FROM Chats WHERE Id = @chatId";

                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@chatId", chatId);
                    connection.Open();

                    using (var reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new ChatInfo
                            {
                                Id = reader["Id"].ToString(),
                                Name = reader["Name"].ToString(),
                                IsPublic = (bool)reader["IsPublic"],
                                Description = reader["Description"] as string,
                                Codeword = reader["Codeword"] as string,
                                ShareLink = reader["ShareLink"] as string
                            };
                        }
                    }
                }
            }

            return null;
        }

        [WebMethod]
        public static ChatShareInfo GetChatShareInfo(string chatId)
        {
            var userId = HttpContext.Current.User.Identity.GetUserId();
            if (string.IsNullOrEmpty(userId))
                return null;

            using (var connection = new SqlConnection(GetConnectionString()))
            {
                // Check if user has access to the chat
                var accessQuery = @"SELECT COUNT(*) FROM UserChats 
                           WHERE ChatId = @chatId AND UserId = @userId
                           UNION ALL
                           SELECT COUNT(*) FROM Chats 
                           WHERE Id = @chatId AND CreatorId = @userId";

                using (var command = new SqlCommand(accessQuery, connection))
                {
                    command.Parameters.AddWithValue("@chatId", chatId);
                    command.Parameters.AddWithValue("@userId", userId);
                    connection.Open();

                    using (var reader = command.ExecuteReader())
                    {
                        var userAccess = reader.Read() ? (int)reader[0] > 0 : false;
                        var isCreator = reader.NextResult() && reader.Read() ? (int)reader[0] > 0 : false;

                        if (!userAccess && !isCreator)
                        {
                            return null;
                        }
                    }
                }

                // Get chat share info
                var query = "SELECT Name, ShareLink, Codeword, IsPublic FROM Chats WHERE Id = @chatId";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@chatId", chatId);

                    using (var reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new ChatShareInfo
                            {
                                ChatId = chatId,
                                Name = reader["Name"].ToString(),
                                ShareLink = reader["ShareLink"].ToString(),
                                Codeword = reader["Codeword"] as string,
                                IsPublic = (bool)reader["IsPublic"]
                            };
                        }
                    }
                }
            }

            return null;
        }

        [WebMethod]
        public static OperationResult SendMessage(string chatId, string messageText)
        {
            var userId = HttpContext.Current.User.Identity.GetUserId();
            if (string.IsNullOrEmpty(userId))
                return new OperationResult { Success = false, Error = "User not authenticated" };

            using (var connection = new SqlConnection(GetConnectionString()))
            {
                connection.Open();

                // First check if the user is a member of this chat
                var membershipQuery = "SELECT COUNT(*) FROM UserChats WHERE ChatId = @chatId AND UserId = @userId";
                using (var command = new SqlCommand(membershipQuery, connection))
                {
                    command.Parameters.AddWithValue("@chatId", chatId);
                    command.Parameters.AddWithValue("@userId", userId);

                    int memberCount = (int)command.ExecuteScalar();
                    if (memberCount > 0)
                    {
                        // User is a member, allow sending message
                    }
                    else
                    {
                        return new OperationResult { Success = false, Error = "No access to this chat" };
                    }
                }

                // Insert message
                var insertQuery = "INSERT INTO Messages (Id, ChatId, UserId, Text, SentAt) VALUES (@id, @chatId, @userId, @text, @sentAt)";
                using (var command = new SqlCommand(insertQuery, connection))
                {
                    command.Parameters.AddWithValue("@id", Guid.NewGuid().ToString());
                    command.Parameters.AddWithValue("@chatId", chatId);
                    command.Parameters.AddWithValue("@userId", userId);
                    command.Parameters.AddWithValue("@text", messageText);
                    command.Parameters.AddWithValue("@sentAt", DateTime.UtcNow);

                    command.ExecuteNonQuery();
                }
            }

            return new OperationResult { Success = true };
        }

        [WebMethod]
        public static OperationResult CreateChat(string name, bool isPublic, string codeword, string description)
        {
            var userId = HttpContext.Current.User.Identity.GetUserId();
            if (string.IsNullOrEmpty(userId))
                return new OperationResult { Success = false, Error = "User not authenticated" };

            // Валідація: кодове слово обов'язкове для всіх чатів
            if (string.IsNullOrEmpty(codeword))
                return new OperationResult { Success = false, Error = "Codeword is required for all chats" };

            using (var connection = new SqlConnection(GetConnectionString()))
            {
                connection.Open();

                var chatId = Guid.NewGuid().ToString();
                var shareLink = GenerateShareLink(chatId, name);

                var query = @"INSERT INTO Chats (Id, Name, IsPublic, Codeword, Description, CreatorId, CreatedAt, ShareLink) 
                      VALUES (@id, @name, @isPublic, @codeword, @description, @creatorId, @createdAt, @shareLink)";

                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@id", chatId);
                    command.Parameters.AddWithValue("@name", name);
                    command.Parameters.AddWithValue("@isPublic", isPublic);
                    command.Parameters.AddWithValue("@codeword", codeword.Trim());
                    command.Parameters.AddWithValue("@description", string.IsNullOrEmpty(description) ? "" : description);
                    command.Parameters.AddWithValue("@creatorId", userId);
                    command.Parameters.AddWithValue("@createdAt", DateTime.UtcNow);
                    command.Parameters.AddWithValue("@shareLink", shareLink);

                    command.ExecuteNonQuery();
                }

                query = "INSERT INTO UserChats (UserId, ChatId, JoinedAt) VALUES (@userId, @chatId, @joinedAt)";
                using (var command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@userId", userId);
                    command.Parameters.AddWithValue("@chatId", chatId);
                    command.Parameters.AddWithValue("@joinedAt", DateTime.UtcNow);

                    command.ExecuteNonQuery();
                }

                return new OperationResult
                {
                    Success = true,
                    ChatInfo = new ChatShareInfo
                    {
                        ChatId = chatId,
                        Name = name,
                        ShareLink = shareLink,
                        Codeword = codeword,
                        IsPublic = isPublic
                    }
                };
            }
        }

        private static string GenerateShareLink(string chatId, string chatName)
        {
            string slug = GenerateSlug(chatName);
            string shortId = chatId.Replace("-", "").Substring(0, 8);
            return string.Format("https://bazar.app/chat/{0}-{1}",
                HttpUtility.UrlEncode(slug), shortId);
        }

        private static string GenerateSlug(string text)
        {
            if (string.IsNullOrEmpty(text))
                return "chat";

            var transliterationMap = new Dictionary<char, string>
            {
                {'а', "a"}, {'б', "b"}, {'в', "v"}, {'г', "g"}, {'д', "d"}, {'е', "e"}, {'є', "ye"},
                {'ж', "zh"}, {'з', "z"}, {'и', "y"}, {'і', "i"}, {'ї', "yi"}, {'й', "y"}, {'к', "k"},
                {'л', "l"}, {'м', "m"}, {'н', "n"}, {'о', "o"}, {'п', "p"}, {'р', "r"}, {'с', "s"},
                {'т', "t"}, {'у', "u"}, {'ф', "f"}, {'х', "h"}, {'ц', "ts"}, {'ч', "ch"}, {'ш', "sh"},
                {'щ', "sch"}, {'ь', ""}, {'ю', "yu"}, {'я', "ya"},
                {'А', "A"}, {'Б', "B"}, {'В', "V"}, {'Г', "G"}, {'Д', "D"}, {'Е', "E"}, {'Є', "Ye"},
                {'Ж', "Zh"}, {'З', "Z"}, {'И', "Y"}, {'І', "I"}, {'Ї', "Yi"}, {'Й', "Y"}, {'К', "K"},
                {'Л', "L"}, {'М', "M"}, {'Н', "N"}, {'О', "O"}, {'П', "P"}, {'Р', "R"}, {'С', "S"},
                {'Т', "T"}, {'У', "U"}, {'Ф', "F"}, {'Х', "H"}, {'Ц', "Ts"}, {'Ч', "Ch"}, {'Ш', "Sh"},
                {'Щ', "Sch"}, {'Ь', ""}, {'Ю', "Yu"}, {'Я', "Ya"}
            };

            text = text.ToLowerInvariant();
            var result = new StringBuilder();
            foreach (char c in text)
            {
                if (transliterationMap.ContainsKey(c))
                    result.Append(transliterationMap[c]);
                else if (char.IsLetterOrDigit(c))
                    result.Append(c);
                else if (c == ' ' || c == '-' || c == '_')
                    result.Append("-");
            }

            string slug = result.ToString();
            while (slug.Contains("--"))
                slug = slug.Replace("--", "-");
            slug = slug.Trim('-');
            if (string.IsNullOrEmpty(slug))
                return "chat";
            if (slug.Length > 50)
                slug = slug.Substring(0, 50);
            return slug;
        }

        [WebMethod]
public static OperationResult JoinChat(string chatId, string codeword)
{
    var userId = HttpContext.Current.User.Identity.GetUserId();
    if (string.IsNullOrEmpty(userId))
        return new OperationResult { Success = false, Error = "User not authenticated" };
    using (var connection = new SqlConnection(GetConnectionString()))
    {
        connection.Open();
        // Перевірка існування чату та кодового слова
        string checkQuery = "SELECT Id, Name, IsPublic, Codeword FROM Chats WHERE Id = @chatId";
        using (var command = new SqlCommand(checkQuery, connection))
        {
            command.Parameters.AddWithValue("@chatId", chatId);
            using (var reader = command.ExecuteReader())
            {
                if (!reader.Read())
                    return new OperationResult { Success = false, Error = "Chat not found" };
                string chatCodeword = reader["Codeword"] as string;
                // Перевірка кодового слова для всіх чатів
                if (string.IsNullOrEmpty(codeword) || codeword.Trim() != (chatCodeword != null ? chatCodeword.Trim() : null))
                    return new OperationResult { Success = false, Error = "Invalid codeword" };
            }
        }

        // Перевірка, чи користувач уже в чаті
        string checkMembershipQuery = "SELECT COUNT(*) FROM UserChats WHERE UserId = @userId AND ChatId = @chatId";
        using (var command = new SqlCommand(checkMembershipQuery, connection))
        {
            command.Parameters.AddWithValue("@userId", userId);
            command.Parameters.AddWithValue("@chatId", chatId);

            int memberCount = (int)command.ExecuteScalar();
            if (memberCount > 0)
                return new OperationResult { Success = true, Message = "Already a member of this chat" };
        }

        // Додавання користувача до чату
        string joinQuery = "INSERT INTO UserChats (UserId, ChatId, JoinedAt) VALUES (@userId, @chatId, @joinedAt)";
        using (var command = new SqlCommand(joinQuery, connection))
        {
            command.Parameters.AddWithValue("@userId", userId);
            command.Parameters.AddWithValue("@chatId", chatId);
            command.Parameters.AddWithValue("@joinedAt", DateTime.UtcNow);

            command.ExecuteNonQuery();
        }

        return new OperationResult { Success = true, Message = "Successfully joined the chat" };
    }
}

        [WebMethod]
        public static OperationResult ValidateShareLink(string shareLink)
        {
            try
            {
                Uri uri = new Uri(shareLink);
                string path = uri.AbsolutePath;
                string lastSegment = path.Split('/').Last();
                int lastDashIndex = lastSegment.LastIndexOf('-');
                if (lastDashIndex == -1 || lastDashIndex + 1 >= lastSegment.Length)
                    return new OperationResult { Success = false, Error = "Invalid share link format" };

                string shortId = lastSegment.Substring(lastDashIndex + 1);

                using (var connection = new SqlConnection(GetConnectionString()))
                {
                    connection.Open();

                    string query = "SELECT TOP 1 Id, Name, IsPublic FROM Chats WHERE Id LIKE @shortIdPattern";
                    using (var command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@shortIdPattern", "%" + shortId + "%");

                        using (var reader = command.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                return new OperationResult
                                {
                                    Success = true,
                                    ChatInfo = new ChatShareInfo
                                    {
                                        ChatId = reader["Id"].ToString(),
                                        Name = reader["Name"].ToString(),
                                        IsPublic = (bool)reader["IsPublic"]
                                    }
                                };
                            }
                        }
                    }
                }

                return new OperationResult { Success = false, Error = "Chat not found" };
            }
            catch (Exception ex)
            {
                return new OperationResult { Success = false, Error = "Invalid share link: " + ex.Message };
            }
        }

        [WebMethod]
        public static OperationResult Login(string email, string password, bool rememberMe)
        {
            var signinManager = HttpContext.Current.GetOwinContext().Get<ApplicationSignInManager>();
            var result = signinManager.PasswordSignIn(email, password, rememberMe, shouldLockout: false);

            switch (result)
            {
                case SignInStatus.Success:
                    var userManager = HttpContext.Current.GetOwinContext().GetUserManager<ApplicationUserManager>();
                    var user = userManager.FindByEmail(email);

                    return new OperationResult
                    {
                        Success = true,
                        UserInfo = new UserInfo
                        {
                            Email = user.Email,
                            FullName = user.FullName
                        }
                    };
                case SignInStatus.LockedOut:
                    return new OperationResult { Success = false, Error = "Account locked out" };
                case SignInStatus.RequiresVerification:
                    return new OperationResult { Success = false, Error = "Requires verification" };
                default:
                    return new OperationResult { Success = false, Error = "Invalid login attempt" };
            }
        }

        [WebMethod]
        public static OperationResult Register(string name, string email, string password, string confirmPassword)
        {
            if (password != confirmPassword)
                return new OperationResult { Success = false, Error = "Passwords do not match" };

            var userManager = HttpContext.Current.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var user = new ApplicationUser { UserName = email, Email = email, FullName = name };
            var result = userManager.Create(user, password);

            if (result.Succeeded)
            {
                var signinManager = HttpContext.Current.GetOwinContext().Get<ApplicationSignInManager>();
                signinManager.SignIn(user, isPersistent: false, rememberBrowser: false);
                return new OperationResult { Success = true };
            }

            return new OperationResult
            {
                Success = false,
                Error = string.Join(". ", result.Errors)
            };
        }

        [WebMethod]
        public static OperationResult Logout()
        {
            var authManager = HttpContext.Current.GetOwinContext().Authentication;
            authManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return new OperationResult { Success = true };
        }

        private static string GetConnectionString()
        {
            return System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        }
    }

    public class AuthStatus
    {
        public bool IsAuthenticated { get; set; }
        public UserInfo User { get; set; }
    }

    public class UserInfo
    {
        public string Email { get; set; }
        public string FullName { get; set; }
    }

    public class ChatInfo
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public bool IsPublic { get; set; }
        public string Description { get; set; }
        public string LastMessage { get; set; }
        public DateTime? LastMessageTime { get; set; }
        public DateTime CreatedAt { get; set; }
        public string ShareLink { get; set; }
        public string Codeword { get; set; }
    }

    public class ChatShareInfo
    {
        public string ChatId { get; set; }
        public string Name { get; set; }
        public string ShareLink { get; set; }
        public string Codeword { get; set; }
        public bool IsPublic { get; set; }
    }

    public class MessageInfo
    {
        public string Id { get; set; }
        public string Text { get; set; }
        public DateTime SentAt { get; set; }
        public string UserName { get; set; }
        public bool IsCurrentUser { get; set; }
    }

    public class OperationResult
    {
        public bool Success { get; set; }
        public string Error { get; set; }
        public string Message { get; set; }
        public UserInfo UserInfo { get; set; }
        public ChatShareInfo ChatInfo { get; set; }
    }

    public class PlatformStatistics
    {
        public int TotalChats { get; set; }
        public int PublicChats { get; set; }
        public int PrivateChats { get; set; }
        public int TotalMessages { get; set; }
    }
}