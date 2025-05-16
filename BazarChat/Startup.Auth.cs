using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.Google;
using Microsoft.Owin.Security.Facebook;
using Owin;
using System;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Configuration;
using BazarChat.Models;

[assembly: OwinStartup(typeof(BazarChat.Startup))]
namespace BazarChat
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }

        public void ConfigureAuth(IAppBuilder app)
        {
            // Configure the db context, user manager and signin manager to use a single instance per request
            app.CreatePerOwinContext(ApplicationDbContext.Create);
            app.CreatePerOwinContext<ApplicationUserManager>(ApplicationUserManager.Create);
            app.CreatePerOwinContext<ApplicationSignInManager>(ApplicationSignInManager.Create);

            // Enable the application to use a cookie to store information for the signed in user
            // and to use a cookie to temporarily store information about a user logging in with a third party login provider
            // Configure the sign in cookie
            app.UseCookieAuthentication(new CookieAuthenticationOptions
            {
                AuthenticationType = DefaultAuthenticationTypes.ApplicationCookie,
                LoginPath = new PathString("/Default.aspx"),
                Provider = new CookieAuthenticationProvider
                {
                    // Enables the application to validate the security stamp when the user logs in.
                    // This is a security feature which is used when you change a password or add an external login to your account.  
                    OnValidateIdentity = SecurityStampValidator.OnValidateIdentity<ApplicationUserManager, ApplicationUser>(
                        validateInterval: TimeSpan.FromMinutes(30),
                        regenerateIdentity: (manager, user) => user.GenerateUserIdentityAsync(manager))
                }
            });

            // Enable the application to temporarily store user information when they are verifying the second factor in the two-factor authentication process.
            app.UseExternalSignInCookie(DefaultAuthenticationTypes.ExternalCookie);

            // Configure Google Authentication
            var googleClientId = ConfigurationManager.AppSettings["GoogleClientId"];
            var googleClientSecret = ConfigurationManager.AppSettings["GoogleClientSecret"];

            if (!string.IsNullOrEmpty(googleClientId) && !string.IsNullOrEmpty(googleClientSecret))
            {
                var googleOptions = new GoogleOAuth2AuthenticationOptions()
                {
                    ClientId = googleClientId,
                    ClientSecret = googleClientSecret,
                    CallbackPath = new PathString("/signin-google"),
                    Provider = new GoogleOAuth2AuthenticationProvider
                    {
                        OnAuthenticated = context =>
                        {
                            // Зберегти додаткову інформацію про користувача
                            context.Identity.AddClaim(new Claim("urn:google:name", context.Identity.FindFirstValue(ClaimTypes.Name) ?? ""));
                            context.Identity.AddClaim(new Claim("urn:google:email", context.Identity.FindFirstValue(ClaimTypes.Email) ?? ""));
                            return Task.CompletedTask;
                        }
                    }
                };
                app.UseGoogleAuthentication(googleOptions);
            }

            // Configure Facebook Authentication
            var facebookAppId = ConfigurationManager.AppSettings["FacebookAppId"];
            var facebookAppSecret = ConfigurationManager.AppSettings["FacebookAppSecret"];

            if (!string.IsNullOrEmpty(facebookAppId) && !string.IsNullOrEmpty(facebookAppSecret))
            {
                var facebookOptions = new FacebookAuthenticationOptions()
                {
                    AppId = facebookAppId,
                    AppSecret = facebookAppSecret,
                    CallbackPath = new PathString("/signin-facebook"),
                    Provider = new FacebookAuthenticationProvider()
                    {
                        OnAuthenticated = context =>
                        {
                            context.Identity.AddClaim(new Claim("urn:facebook:name", context.Identity.FindFirstValue(ClaimTypes.Name) ?? ""));
                            context.Identity.AddClaim(new Claim("urn:facebook:email", context.Identity.FindFirstValue(ClaimTypes.Email) ?? ""));
                            return Task.CompletedTask;
                        }
                    }
                };
                facebookOptions.Scope.Add("email");
                facebookOptions.Scope.Add("public_profile");
                app.UseFacebookAuthentication(facebookOptions);
            }
        }
    }
}