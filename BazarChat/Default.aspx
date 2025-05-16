<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="BazarChat.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Базар - Народна платформа</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary-color: #4a6fa5;
            --secondary-color: #166088;
            --accent-color: #4fc3f7;
            --light-color: #e3f2fd;
            --dark-color: #263238;
            --success-color: #66bb6a;
            --warning-color: #ffa726;
            --danger-color: #ef5350;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f5f5f5;
            color: var(--dark-color);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        header {
            background-color: var(--primary-color);
            color: white;
            padding: 15px 0;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            display: flex;
            align-items: center;
        }

        .logo i {
            margin-right: 10px;
            font-size: 28px;
        }

        .nav-items {
            display: flex;
            gap: 20px;
        }

        .nav-items a {
            color: white;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .nav-items a:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .auth-buttons {
            display: flex;
            gap: 10px;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
        }

        .btn-primary {
            background-color: var(--accent-color);
            color: white;
        }

        .btn-primary:hover {
            background-color: #29b6f6;
        }

        .btn-outline {
            background-color: transparent;
            border: 1px solid white;
            color: white;
        }

        .btn-outline:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

.btn-success {
    background-color: #4fc3f7; 
    color: white;
}
.btn-success:hover {
    background-color: #29b6f6;
}

        .main-content {
            display: grid;
            grid-template-columns: 1fr 3fr;
            gap: 20px;
            margin-top: 20px;
        }

        .sidebar {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 20px;
        }

        .sidebar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .sidebar-title {
            font-size: 18px;
            font-weight: 600;
        }

        .chat-list {
            list-style: none;
            margin-top: 15px;
            max-height: calc(100vh - 400px);
            overflow-y: auto;
            padding-right: 8px;
        }

        .chat-list::-webkit-scrollbar {
            width: 6px;
        }

        .chat-list::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 3px;
        }

        .chat-list::-webkit-scrollbar-thumb {
            background: #c1c1c1;
            border-radius: 3px;
        }

        .chat-list::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }

        .chat-item {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: background-color 0.3s;
            display: flex;
            align-items: center;
        }

        .chat-item:hover {
            background-color: #f5f5f5;
        }

        .chat-item.active {
            background-color: var(--light-color);
            border-left: 3px solid var(--primary-color);
        }

        .chat-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--secondary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            font-size: 18px;
        }

        .chat-details {
            flex-grow: 1;
        }

        .chat-name {
            font-weight: 500;
            margin-bottom: 3px;
        }

        .chat-last-message {
            font-size: 12px;
            color: #757575;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 150px;
        }

        .chat-meta {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
        }

        .chat-time {
            font-size: 11px;
            color: #757575;
        }

        .chat-badge {
            background-color: var(--accent-color);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            margin-top: 5px;
        }

        .chat-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .chat-actions .btn {
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
            flex: 1;
        }

        .chat-actions .btn-outline {
            background-color: #4a6fa5;
            color: white;
            border: none;
        }

        .chat-actions .btn-outline:hover {
            background-color: #166088;
        }

        .chat-actions .btn i {
            margin-right: 5px;
        }

        .filters {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        .filter-btn {
            padding: 6px 12px;
            border: 1px solid #e0e0e0;
            border-radius: 20px;
            background-color: white;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s;
        }

        .filter-btn:hover, .filter-btn.active {
            background-color: var(--light-color);
            border-color: var(--primary-color);
            color: var(--primary-color);
        }

        .chat-window {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            height: calc(100vh - 160px);
        }

        .chat-header {
            padding: 15px 20px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .chat-title {
            font-size: 18px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .chat-title i {
            margin-right: 10px;
            color: var(--secondary-color);
        }

        .chat-info {
            color: #757575;
            font-size: 14px;
        }

        .chat-header-actions {
            display: flex;
            gap: 15px;
        }

        .chat-header-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: #757575;
            font-size: 16px;
            transition: color 0.3s;
        }

        .chat-header-btn:hover {
            color: var(--primary-color);
        }

        .messages-container {
            flex-grow: 1;
            padding: 20px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .message {
            max-width: 70%;
            padding: 10px 15px;
            border-radius: 18px;
            position: relative;
            margin-bottom: 5px;
        }

        .message-sender {
            font-weight: 500;
            font-size: 12px;
            margin-bottom: 3px;
        }

        .message-text {
            font-size: 14px;
            line-height: 1.4;
        }

        .message-time {
            font-size: 11px;
            color: #757575;
            margin-top: 2px;
            text-align: right;
        }

        .message.received {
            align-self: flex-start;
            background-color: #f1f1f1;
            border-bottom-left-radius: 5px;
        }

        .message.sent {
            align-self: flex-end;
            background-color: var(--light-color);
            border-bottom-right-radius: 5px;
            color: var(--dark-color);
        }

        .message-input-container {
            padding: 15px;
            border-top: 1px solid #e0e0e0;
            display: flex;
            gap: 10px;
        }

        .message-input {
            flex-grow: 1;
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 24px;
            outline: none;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        .message-input:focus {
            border-color: var(--accent-color);
        }

        .send-btn {
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .send-btn:hover {
            background-color: var(--secondary-color);
        }

        .empty-chat {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #757575;
            text-align: center;
            padding: 0 20px;
        }

        .empty-chat i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #e0e0e0;
        }

        .stats-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-top: 20px;
        }

        .stats-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .stat-card {
            background-color: var(--light-color);
            border-radius: 6px;
            padding: 15px;
            text-align: center;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 14px;
            color: #757575;
        }

        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            display: none;
        }

        .modal {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 500px;
            overflow: hidden;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        .modal-header {
            padding: 15px 20px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 18px;
            font-weight: 600;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #757575;
        }

        .modal-body {
            padding: 20px;
        }

        .modal-footer {
            padding: 15px 20px;
            border-top: 1px solid #e0e0e0;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .form-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
        }

        .form-select {
            width: 100%;
            padding: 10px;
            border: 1px solid #e0e0e0;
            border-radius: 4px;
            font-size: 14px;
        }

        .radio-group {
            display: flex;
            gap: 15px;
            margin-top: 5px;
        }

        .radio-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .radio-label {
            font-size: 14px;
        }

        .share-link {
            background-color: #f5f5f5;
            padding: 12px;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
        }

        .link-text {
            font-size: 14px;
            color: #757575;
            flex-grow: 1;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .copy-btn {
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 4px;
            padding: 6px 12px;
            cursor: pointer;
            font-size: 13px;
            transition: background-color 0.3s;
        }

        .copy-btn:hover {
            background-color: var(--secondary-color);
        }

        .social-login-title {
            text-align: center;
            position: relative;
            margin-bottom: 15px;
            padding: 0 10px;
            display: inline-block;
            background-color: white;
        }

        .social-login-title::before {
            content: "";
            position: absolute;
            top: 50%;
            left: -45%;
            width: 45%;
            height: 1px;
            background-color: #e0e0e0;
        }

        .social-login-title::after {
            content: "";
            position: absolute;
            top: 50%;
            right: -45%;
            width: 45%;
            height: 1px;
            background-color: #e0e0e0;
        }

        .social-login {
            margin-top: 20px;
            text-align: center;
        }

        .social-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .social-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            cursor: pointer;
            transition: opacity 0.3s;
        }

        .social-btn:hover {
            opacity: 0.9;
        }

        .facebook {
            background-color: #3b5998;
        }

        .google {
            background-color: #db4437;
        }

        .user-profile {
            position: relative;
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .profile-pic {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            margin-right: 8px;
            background-color: var(--accent-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 500;
        }

        .user-name {
            font-weight: 500;
        }

        .profile-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            min-width: 150px;
            z-index: 10;
            margin-top: 5px;
            display: none;
        }

        .profile-menu.active {
            display: block;
        }

        .profile-menu-item {
            padding: 10px 15px;
            font-size: 14px;
            transition: background-color 0.3s;
            cursor: pointer;
        }

        .profile-menu-item:hover {
            background-color: #f5f5f5;
        }

        .profile-menu-item i {
            margin-right: 8px;
            color: #757575;
        }

        #loginModal .modal, #signupModal .modal {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
            }

            .sidebar {
                display: none;
            }
            
            .modal {
                width: 95%;
                max-height: 90vh;
                overflow-y: auto;
            }
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <header>
            <div class="container header-content">
                <div class="logo">
                    <i class="fas fa-comments"></i>
                    Базар
                </div>
     
                <div class="auth-buttons">
                    <button type="button" class="btn btn-outline" id="loginBtn">Увійти</button>
                    <button type="button" class="btn btn-primary" id="signupBtn">Реєстрація</button>
                </div>
                <div class="user-profile" style="display: none;">
                    <div class="profile-pic"></div>
                    <div class="user-name"></div>
                    <i class="fas fa-chevron-down" style="margin-left: 5px; font-size: 12px;"></i>
                    <div class="profile-menu">
                
                        <div class="profile-menu-item logout-btn">
                            <i class="fas fa-sign-out-alt"></i> Вийти
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <div class="container">
            <div class="main-content">
                <div class="sidebar">
                    <div class="sidebar-header">
                        <div class="sidebar-title">Мої чати</div>
                        <button type="button" class="btn btn-primary" id="newChatBtn">
                            <i class="fas fa-plus"></i> Новий чат
                        </button>
                    </div>
                    <div class="filters">
                        <button type="button" class="filter-btn active" data-filter="all">Всі</button>
                        <button type="button" class="filter-btn" data-filter="public">Публічні</button>
                        <button type="button" class="filter-btn" data-filter="private">Приватні</button>
                    </div>
                    <ul class="chat-list">
                        <!-- Chat list will be populated dynamically -->
                    </ul>
                    <div class="chat-actions">
                        <button type="button" class="btn btn-outline" id="randomChatBtn">
                            <i class="fas fa-random"></i> Випадковий чат
                        </button>
                        <button type="button" class="btn btn-outline" id="popularChatBtn">
                            <i class="fas fa-star"></i> Популярний чат
                        </button>
                    </div>
                </div>
                <div class="chat-window">
                    <div class="chat-header">
                        <div class="chat-title">
                            <i class="fas fa-comments"></i> Оберіть чат
                            <span class="chat-info" style="margin-left: 10px;"></span>
                        </div>
                        <div class="chat-header-actions">
                            <button type="button" class="chat-header-btn" id="shareChatBtn">
                                <i class="fas fa-share-alt"></i>
                            </button>
                            <button type="button" class="chat-header-btn">
                                <i class="fas fa-info-circle"></i>
                            </button>
                        </div>
                    </div>
                    <div class="messages-container">
                        <div class="empty-chat">
                            <i class="fas fa-comments"></i>
                            <h3>Немає обраного чату</h3>
                            <p>Оберіть існуючий чат зі списку або створіть новий</p>
                        </div>
                    </div>
                    <div class="message-input-container">
                        <input type="text" class="message-input" placeholder="Напишіть повідомлення..." />
                        <button type="button" class="send-btn">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div class="stats-container">
                <div class="stats-title">Статистика платформи</div>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-value">0</div>
                        <div class="stat-label">Всього чатів</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">0</div>
                        <div class="stat-label">Публічних чатів</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">0</div>
                        <div class="stat-label">Приватних чатів</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">0</div>
                        <div class="stat-label">Всього повідомлень</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Модальні вікна -->
        <div class="modal-backdrop" id="newChatModal">
            <div class="modal">
                <div class="modal-header">
                    <div class="modal-title">Створити новий чат</div>
                    <button type="button" class="modal-close">×</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Назва чату</label>
                        <input type="text" class="form-input" id="chatNameInput" placeholder="Введіть назву чату" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Тип чату</label>
                        <div class="radio-group">
                            <div class="radio-item">
                                <input type="radio" name="chatType" id="publicChat" checked />
                                <label for="publicChat" class="radio-label">Публічний</label>
                            </div>
                            <div class="radio-item">
                                <input type="radio" name="chatType" id="privateChat" />
                                <label for="privateChat" class="radio-label">Приватний</label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="codewordGroup">
                        <label class="form-label">Кодове слово</label>
                        <input type="text" class="form-input" id="codewordInput" placeholder="Введіть кодове слово" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Опис чату</label>
                        <textarea class="form-input" id="chatDescriptionInput" placeholder="Введіть опис чату" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline modal-close-btn">Скасувати</button>
                    <button type="button" class="btn btn-success" id="createChatBtn">Створити чат</button>
                </div>
            </div>
        </div>

        <!-- Login Modal -->
        <div class="modal-backdrop" id="loginModal">
            <div class="modal">
                <div class="modal-header">
                    <div class="modal-title">Вхід на платформу</div>
                    <button type="button" class="modal-close">×</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Email або логін</label>
                        <input type="text" class="form-input" id="loginEmail" placeholder="Введіть email або логін" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Пароль</label>
                        <input type="password" class="form-input" id="loginPassword" placeholder="Введіть пароль" />
                        <div id="loginErrorMsg" class="error-message" style="color: var(--danger-color); font-size: 12px; margin-top: 5px; display: none;"></div>
                    </div>
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px;">
                        <div class="radio-item">
                            <input type="checkbox" id="rememberMe" />
                            <label for="rememberMe" class="radio-label">Запам'ятати мене</label>
                        </div>
                        <a href="#" id="forgotPasswordLink" style="font-size: 14px; color: var(--primary-color);">Забули пароль?</a>
                    </div>
                    <div class="social-login">
                        <span class="social-login-title">Або увійдіть через</span>
                        <div class="social-buttons">
                            <div class="social-btn facebook" id="facebookLoginBtn">
                                <i class="fab fa-facebook-f"></i>
                            </div>
                            <div class="social-btn google" id="googleLoginBtn">
                                <i class="fab fa-google"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline modal-close-btn">Скасувати</button>
                    <button type="button" class="btn btn-primary" id="loginSubmitBtn">Увійти</button>
                </div>
            </div>
        </div>

        <!-- Signup Modal -->
        <div class="modal-backdrop" id="signupModal">
            <div class="modal">
                <div class="modal-header">
                    <div class="modal-title">Реєстрація</div>
                    <button type="button" class="modal-close">×</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Ім'я</label>
                        <input type="text" class="form-input" id="signupName" placeholder="Введіть ваше ім'я" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-input" id="signupEmail" placeholder="Введіть ваш email" />
                        <div id="emailErrorMsg" class="error-message" style="color: var(--danger-color); font-size: 12px; margin-top: 5px; display: none;"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Пароль</label>
                        <input type="password" class="form-input" id="signupPassword" placeholder="Створіть пароль" />
                        <div class="password-strength" style="margin-top: 5px; font-size: 12px;">
                            <div class="strength-meter" style="display: flex; margin-bottom: 3px;">
                                <div class="strength-segment" style="height: 4px; flex-grow: 1; background-color: #e0e0e0; margin-right: 2px;"></div>
                                <div class="strength-segment" style="height: 4px; flex-grow: 1; background-color: #e0e0e0; margin-right: 2px;"></div>
                                <div class="strength-segment" style="height: 4px; flex-grow: 1; background-color: #e0e0e0;"></div>
                            </div>
                            <span class="strength-text" style="color: #757575;">Надійність паролю</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Підтвердження паролю</label>
                        <input type="password" class="form-input" id="signupPasswordConfirm" placeholder="Підтвердіть пароль" />
                        <div id="passwordErrorMsg" class="error-message" style="color: var(--danger-color); font-size: 12px; margin-top: 5px; display: none;"></div>
                    </div>
                    <div class="radio-item" style="margin-top: 10px;">
                        <input type="checkbox" id="termsAgree" />
                        <label for="termsAgree" class="radio-label">Я погоджуюсь з <a href="#" style="color: var(--primary-color);">умовами використання</a></label>
                    </div>
                    <div class="social-login">
                        <span class="social-login-title">Або зареєструйтесь через</span>
                        <div class="social-buttons">
                            <div class="social-btn facebook" id="facebookSignupBtn">
                                <i class="fab fa-facebook-f"></i>
                            </div>
                            <div class="social-btn google" id="googleSignupBtn">
                                <i class="fab fa-google"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline modal-close-btn">Скасувати</button>
                    <button type="button" class="btn btn-primary" id="signupSubmitBtn">Зареєструватися</button>
                </div>
            </div>
        </div>

        <!-- Share Chat Modal -->
        <div class="modal-backdrop" id="shareChatModal">
            <div class="modal">
                <div class="modal-header">
                    <div class="modal-title">Поділитися чатом</div>
                    <button type="button" class="modal-close">×</button>
                </div>
                <div class="modal-body">
                    <p>Скопіюйте посилання нижче, щоб поділитися доступом до цього чату:</p>
                    <div class="share-link">
                        <div class="link-text">https://bazar.app/chat/tech-dept-12345</div>
                        <button type="button" class="copy-btn">Копіювати</button>
                    </div>
                    <div class="form-group" style="margin-top: 20px;">
                        <label class="form-label">Кодове слово</label>
                        <input type="text" class="form-input" value="techteam2024" readonly />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline modal-close-btn">Закрити</button>
                </div>
            </div>
        </div>

        <!-- Chat Password Modal -->
        <div class="modal-backdrop" id="chatPasswordModal">
            <div class="modal">
                <div class="modal-header">
                    <div class="modal-title">Введіть пароль чату</div>
                    <button type="button" class="modal-close">×</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label">Пароль</label>
                        <input type="password" class="form-input" id="chatPasswordInput" placeholder="Введіть пароль чату" />
                        <div id="chatPasswordErrorMsg" class="error-message" style="color: var(--danger-color); font-size: 12px; margin-top: 5px; display: none;"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline modal-close-btn">Скасувати</button>
                    <button type="button" class="btn btn-primary" id="submitChatPassword">Підтвердити</button>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            // Global variables
            var activeChatId = null;
            var currentUser = null;

            // Initialize the page
            $(document).ready(function () {
                checkAuthStatus();
                setupEventHandlers();
            });

            // Check authentication status
            function checkAuthStatus() {
                $.ajax({
                    url: 'Default.aspx/CheckAuthStatus',
                    type: 'POST',
                    contentType: 'application/json',
                    success: function (response) {
                        console.log('Auth status:', response.d); // Debug log
                        if (response.d.isAuthenticated) {
                            currentUser = response.d.user;
                            updateUIForAuthenticatedUser(currentUser);
                            loadChats();
                            loadPlatformStatistics();
                            if (!activeChatId) {
                                showEmptyChat();
                            }
                        } else {
                            updateUIForAnonymousUser();
                            showLoginPrompt();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('CheckAuthStatus error:', error);
                        updateUIForAnonymousUser();
                        showLoginPrompt();
                    }
                });
            }

            // Show login prompt for non-authenticated users
            function showLoginPrompt() {
                var container = $('.messages-container');
                container.empty();
                container.append(
                    '<div class="empty-chat login-prompt">' +
                    '<i class="fas fa-lock"></i>' +
                    '<h3>Увійдіть, щоб отримати доступ до чатів</h3>' +
                    '<p>Вам потрібно увійти або зареєструватися, щоб бачити та використовувати чати.</p>' +
                    '<button class="btn btn-primary login-prompt-btn">Увійти</button>' +
                    '</div>'
                );

                $('.chat-list').empty();
                $('#randomChatBtn, #popularChatBtn').hide();
                $('.chat-title i').next().text('Чат недоступний');
                $('.chat-info').text('Увійдіть, щоб отримати доступ');

                $('.login-prompt-btn').click(function () {
                    openModal('loginModal');
                });
            }

            // Check if user has access to chat
            function hasChatAccess(chatId) {
                return localStorage.getItem('chatAccess_' + chatId) === 'true';
            }

            // Set chat access
            function setChatAccess(chatId) {
                localStorage.setItem('chatAccess_' + chatId, 'true');
            }

            // Load chats from server
            function loadChats(filter = 'all') {
                if (!currentUser) {
                    return;
                }

                $.ajax({
                    url: 'Default.aspx/GetChats',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        filter: filter,
                        includeUserChats: true
                    }),
                    success: function (response) {
                        renderChats(response.d);
                    },
                    error: function (xhr, status, error) {
                        console.error("Error loading chats:", error);
                    }
                });
            }

            function renderChats(chats) {
                var chatList = $('.chat-list');
                chatList.empty();

                // Створюємо набір для відстеження унікальних chat.Id
                var renderedChatIds = new Set();

                chats.forEach(function (chat) {
                    // Додаємо чат лише якщо його ще не було додано
                    if (!renderedChatIds.has(chat.Id)) {
                        var chatItem = $('<li class="chat-item" data-chat-id="' + chat.Id + '"></li>');
                        chatItem.append('<div class="chat-icon">' + chat.Name.charAt(0).toUpperCase() + '</div>');

                        var nameSection = '<div class="chat-name">' + chat.Name;
                        // Додаємо іконку залежно від типу чату
                        if (!chat.IsPublic) {
                            nameSection += ' <i class="fas fa-lock" style="font-size: 12px;"></i>';
                        } else {
                            nameSection += ' <i class="fas fa-globe" style="font-size: 12px;"></i>';
                        }
                        nameSection += '</div>';

                        chatItem.append('<div class="chat-details">' + nameSection +
                            '<div class="chat-last-message">' + (chat.LastMessage || 'Немає повідомлень') + '</div></div>');
                        chatItem.append('<div class="chat-meta"><div class="chat-time">' + formatTime(chat.LastMessageTime || chat.CreatedAt) + '</div></div>');

                        chatList.append(chatItem);
                        renderedChatIds.add(chat.Id);
                    }
                });

                $('.chat-item').click(function () {
                    if (!currentUser) {
                        openModal('loginModal');
                        return;
                    }

                    var chatId = $(this).data('chat-id');
                    if (hasChatAccess(chatId)) {
                        $('.chat-item').removeClass('active');
                        $(this).addClass('active');
                        activeChatId = chatId;
                        loadChatMessages(chatId);
                    } else {
                        openChatPasswordModal(chatId, $(this).find('.chat-name').text());
                    }
                });
            }

            // Open chat password modal
            function openChatPasswordModal(chatId, chatName) {
                $('#chatPasswordModal .modal-title').text('Введіть пароль для чату: ' + chatName);
                $('#chatPasswordInput').val('');
                $('#chatPasswordErrorMsg').hide();
                $('#submitChatPassword').data('chat-id', chatId);
                openModal('chatPasswordModal');
            }

            // Load messages for a specific chat
            function loadChatMessages(chatId) {
                if (!currentUser) {
                    openModal('loginModal');
                    return;
                }

                $.ajax({
                    url: 'Default.aspx/GetChatMessages',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ chatId: chatId }),
                    success: function (response) {
                        displayMessages(response.d);
                        updateChatInfo(chatId);

                        if (currentUser) {
                            $('.message-input').prop('disabled', false);
                            $('.message-input').attr('placeholder', 'Введіть повідомлення...');
                            $('.send-btn').removeClass('disabled');
                        } else {
                            $('.message-input').prop('disabled', true);
                            $('.message-input').attr('placeholder', 'Увійдіть, щоб надсилати повідомлення');
                            $('.send-btn').addClass('disabled');
                        }
                    }
                });
            }

            // Display messages in the chat window
            function displayMessages(messages) {
                var container = $('.messages-container');
                container.empty();

                if (messages.length === 0) {
                    container.append('<div class="empty-chat"><i class="fas fa-comments"></i><h3>Немає повідомлень</h3><p>Будьте першим, хто напише в цьому чаті</p></div>');
                } else {
                    messages.forEach(function (msg) {
                        var isCurrentUser = msg.IsCurrentUser;
                        var message = $('<div class="message ' + (isCurrentUser ? 'sent' : 'received') + '"></div>');
                        if (!isCurrentUser) {
                            message.append('<div class="message-sender">' + msg.UserName + '</div>');
                        }
                        message.append('<div class="message-text">' + msg.Text + '</div>');
                        message.append('<div class="message-time">' + formatTime(msg.SentAt) + '</div>');
                        container.append(message);
                    });

                    container.scrollTop(container[0].scrollHeight);
                }
            }

            // Update chat info in the header
            function updateChatInfo(chatId) {
                $.ajax({
                    url: 'Default.aspx/GetChatInfo',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ chatId: chatId }),
                    success: function (response) {
                        $('.chat-title i').next().text(response.d.Name);
                        $('.chat-info').text(response.d.IsPublic ? 'Публічний чат' : 'Приватний чат');
                    }
                });
            }

            // Format time for display
            function formatTime(dateString) {
                if (!dateString) return '';
                try {
                    var date = new Date(dateString);
                    if (!isNaN(date.getTime())) {
                        var localOffset = new Date().getTimezoneOffset();
                        var serverOffset = -180;
                        var offsetDiff = localOffset - serverOffset;
                        date.setMinutes(date.getMinutes() + offsetDiff);
                        return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
                    }
                    var msJsonMatch = /\/Date\((-?\d+)(?:[-+]\d{4})?\)\//.exec(dateString);
                    if (msJsonMatch) {
                        var msTimestamp = parseInt(msJsonMatch[1], 10);
                        var msDate = new Date(msTimestamp);
                        var localOffset = new Date().getTimezoneOffset();
                        var serverOffset = -180;
                        var offsetDiff = localOffset - serverOffset;
                        msDate.setMinutes(msDate.getMinutes() + offsetDiff);
                        if (!isNaN(msDate.getTime())) {
                            return msDate.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
                        }
                    }
                    return '12:00';
                } catch (e) {
                    console.error("Error formatting date:", e, "for date string:", dateString);
                    return '12:00';
                }
            }

            // Update UI for authenticated user
            function updateUIForAuthenticatedUser(user) {
                $('.auth-buttons').hide();
                $('.user-profile').show();
                $('.profile-pic').text(user.FullName ? user.FullName.charAt(0).toUpperCase() : 'U');
                $('.user-name').text(user.FullName || user.Email);
                $('#randomChatBtn, #popularChatBtn').show();
            }

            // Update UI for anonymous user
            function updateUIForAnonymousUser() {
                $('.auth-buttons').show();
                $('.user-profile').hide();
                $('.profile-menu').removeClass('active'); // Ensure menu is hidden
                $('#randomChatBtn, #popularChatBtn').hide();
            }

            // Handle share link
            function handleShareLink() {
                const urlParams = new URLSearchParams(window.location.search);
                const pendingShareLink = sessionStorage.getItem('pendingShareLink');

                if (!currentUser) {
                    if (urlParams.has('join')) {
                        sessionStorage.setItem('pendingShareLink', urlParams.get('join'));
                        openModal('loginModal');
                    }
                    return;
                }

                if (urlParams.has('join')) {
                    const shareLink = decodeURIComponent(urlParams.get('join'));
                    processShareLink(shareLink);
                    return;
                }

                if (pendingShareLink && currentUser) {
                    const shareLink = decodeURIComponent(pendingShareLink);
                    processShareLink(shareLink);
                    sessionStorage.removeItem('pendingShareLink');
                }
            }

            // Process share link
            function processShareLink(shareLink) {
                // Если shareLink не начинается с http:// или https://, добавляем базовый домен
                if (!shareLink.startsWith('http://') && !shareLink.startsWith('https://')) {
                    shareLink = 'https://bazar.app/' + shareLink;
                }

                $.ajax({
                    url: 'Default.aspx/ValidateShareLink',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ shareLink: shareLink }),
                    success: function (response) {
                        if (response.d.Success) {
                            const chatInfo = response.d.ChatInfo;
                            if (hasChatAccess(chatInfo.ChatId)) {
                                joinChat(chatInfo.ChatId, null);
                            } else {
                                openChatPasswordModal(chatInfo.ChatId, chatInfo.Name);
                            }
                        } else {
                            showNotification('error', 'Недійсне посилання: ' + response.d.Error);
                        }
                    }
                });
            }

            // Join a chat
            function joinChat(chatId, codeword) {
                if (!currentUser) {
                    openModal('loginModal');
                    return;
                }

                $.ajax({
                    url: 'Default.aspx/JoinChat',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        chatId: chatId,
                        codeword: codeword
                    }),
                    success: function (response) {
                        if (response.d.Success) {
                            setChatAccess(chatId);
                            loadChats();
                            activeChatId = chatId;
                            $('.chat-item').removeClass('active');
                            $('.chat-item[data-chat-id="' + activeChatId + '"]').addClass('active');
                            loadChatMessages(activeChatId);
                            updateStatistics();
                            closeModal();
                            showNotification('success', response.d.Message || 'Успішно приєднано до чату');
                        } else {
                            $('#chatPasswordErrorMsg').text(response.d.Error || 'Невірний пароль').show();
                        }
                    }
                });
            }

            // Update statistics
            function updateStatistics() {
                if (currentUser) {
                    loadPlatformStatistics();
                }
            }

            // Show notification
            function showNotification(type, message) {
                if ($('#notification').length === 0) {
                    $('body').append('<div id="notification" class="notification"></div>');
                }

                const notification = $('#notification');
                notification.attr('class', 'notification ' + type);
                notification.text(message);
                notification.fadeIn(300);

                setTimeout(function () {
                    notification.fadeOut(300);
                }, 3000);
            }

            // Load platform statistics
            function loadPlatformStatistics() {
                if (!currentUser) {
                    return;
                }

                $.ajax({
                    type: "POST",
                    url: "Default.aspx/GetPlatformStatistics",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        const stats = response.d;
                        document.querySelector('.stat-card:nth-child(1) .stat-value').textContent = stats.TotalChats;
                        document.querySelector('.stat-card:nth-child(2) .stat-value').textContent = stats.PublicChats;
                        document.querySelector('.stat-card:nth-child(3) .stat-value').textContent = stats.PrivateChats;
                        document.querySelector('.stat-card:nth-child(4) .stat-value').textContent = stats.TotalMessages;
                    },
                    error: function (xhr, status, error) {
                        console.error("Error loading platform statistics:", error);
                    }
                });
            }

            // Setup event handlers
            function setupEventHandlers() {
                window.openModal = function (id) {
                    $('#' + id).fadeIn(300);
                };

                window.closeModal = function () {
                    $('.modal-backdrop').fadeOut(300);
                };

                $('#newChatBtn').click(function () {
                    if (!currentUser) {
                        openModal('loginModal');
                        return;
                    }
                    openModal('newChatModal');
                });

                $('#shareChatBtn').click(function () {
                    if (!currentUser) {
                        openModal('loginModal');
                        return;
                    }
                    if (!activeChatId) return;

                    $.ajax({
                        type: "POST",
                        url: "Default.aspx/GetChatShareInfo",
                        data: JSON.stringify({ chatId: activeChatId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d && response.d.ChatId) {
                                $('#shareChatModal .link-text').text(response.d.ShareLink);
                                $('#shareChatModal .form-input').val(response.d.Codeword);
                            }
                            openModal('shareChatModal');
                        },
                        error: function (xhr, status, error) {
                            console.error("Помилка завантаження інформації про чат:", error);
                            openModal('shareChatModal');
                        }
                    });
                });

                $('#loginBtn').click(function () {
                    openModal('loginModal');
                });

                $('#signupBtn').click(function () {
                    openModal('signupModal');
                });

                $(document).on('click', '.modal-close, .modal-close-btn', function () {
                    closeModal();
                });

                $(document).on('click', '.modal-backdrop', function (e) {
                    if ($(e.target).hasClass('modal-backdrop')) {
                        closeModal();
                    }
                });

                $('.filter-btn').click(function () {
                    if (!currentUser) {
                        openModal('loginModal');
                        return;
                    }

                    $('.filter-btn').removeClass('active');
                    $(this).addClass('active');
                    loadChats($(this).data('filter'));
                });

                $('.user-profile').click(function (e) {
                    e.stopPropagation();
                    $('.profile-menu').toggleClass('active');
                });

                $(document).click(function () {
                    $('.profile-menu').removeClass('active');
                });

                $('.copy-btn').click(function () {
                    var copyText = $('.link-text').text();
                    navigator.clipboard.writeText(copyText).then(function () {
                        $('.copy-btn').text('Скопійовано!');
                        setTimeout(function () {
                            $('.copy-btn').text('Копіювати');
                        }, 2000);
                    });
                });

                $('#randomChatBtn').click(function () {
                    if (!currentUser) {
                        openModal('loginModal');
                        return;
                    }

                    $.ajax({
                        url: 'Default.aspx/GetChats',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            filter: 'all',
                            includeUserChats: true
                        }),
                        success: function (response) {
                            const chats = response.d;
                            if (chats && chats.length > 0) {
                                const randomIndex = Math.floor(Math.random() * chats.length);
                                const randomChat = chats[randomIndex];
                                activeChatId = randomChat.Id;
                                if (hasChatAccess(activeChatId)) {
                                    $('.chat-item').removeClass('active');
                                    $('.chat-item[data-chat-id="' + activeChatId + '"]').addClass('active');
                                    loadChatMessages(activeChatId);
                                } else {
                                    openChatPasswordModal(activeChatId, randomChat.Name);
                                }
                            }
                        }
                    });
                });

                $('#popularChatBtn').click(function () {
                    if (!currentUser) {
                        openModal('loginModal');
                        return;
                    }

                    $.ajax({
                        url: 'Default.aspx/GetChats',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            filter: 'public',
                            includeUserChats: true
                        }),
                        success: function (response) {
                            const chats = response.d;
                            if (chats && chats.length > 0) {
                                const popularChat = chats[0];
                                activeChatId = popularChat.Id;
                                if (hasChatAccess(activeChatId)) {
                                    $('.chat-item').removeClass('active');
                                    $('.chat-item[data-chat-id="' + activeChatId + '"]').addClass('active');
                                    loadChatMessages(activeChatId);
                                } else {
                                    openChatPasswordModal(activeChatId, popularChat.Name);
                                }
                            }
                        }
                    });
                });

                $('#submitChatPassword').click(function () {
                    var chatId = $(this).data('chat-id');
                    var password = $('#chatPasswordInput').val().trim();
                    if (!password) {
                        $('#chatPasswordErrorMsg').text('Введіть пароль').show();
                        return;
                    }

                    $.ajax({
                        url: 'Default.aspx/JoinChat',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            chatId: chatId,
                            codeword: password
                        }),
                        success: function (response) {
                            if (response.d.Success) {
                                setChatAccess(chatId);
                                closeModal();
                                $('.chat-item').removeClass('active');
                                $('.chat-item[data-chat-id="' + chatId + '"]').addClass('active');
                                activeChatId = chatId;
                                loadChatMessages(chatId);
                                showNotification('success', 'Успішно приєднано до чату');
                            } else {
                                $('#chatPasswordErrorMsg').text(response.d.Error || 'Невірний пароль').show();
                            }
                        }
                    });
                });

                $('.send-btn').click(sendMessage);
                $('.message-input').keypress(function (e) {
                    if (e.which === 13) {
                        sendMessage();
                        return false;
                    }
                });

                function sendMessage() {
                    if (!currentUser) {
                        openModal('loginModal');
                        return;
                    }

                    var messageText = $('.message-input').val().trim();
                    if (messageText !== '' && activeChatId !== null) {
                        $.ajax({
                            url: 'Default.aspx/SendMessage',
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({
                                chatId: activeChatId,
                                messageText: messageText
                            }),
                            success: function (response) {
                                $('.message-input').val('');
                                loadChatMessages(activeChatId);
                                updateStatistics();
                            }
                        });
                    }
                }

                $('#createChatBtn').click(function () {
                    if (!currentUser) {
                        openModal('loginModal');
                        return;
                    }

                    var chatName = $('#chatNameInput').val().trim();
                    var isPublic = $('#publicChat').is(':checked');
                    var codeword = $('#codewordInput').val().trim();
                    var description = $('#chatDescriptionInput').val().trim();

                    if (chatName !== '') {
                        $.ajax({
                            url: 'Default.aspx/CreateChat',
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({
                                name: chatName,
                                isPublic: isPublic,
                                codeword: codeword,
                                description: description
                            }),
                            success: function (response) {
                                if (response.d.Success) {
                                    setChatAccess(response.d.ChatInfo.ChatId);
                                    closeModal();
                                    loadChats($('.filter-btn.active').data('filter'));
                                    $('#chatNameInput, #codewordInput, #chatDescriptionInput').val('');
                                    $('#publicChat').prop('checked', true);
                                    updateStatistics();
                                }
                            }
                        });
                    }
                });

                $('#loginSubmitBtn').click(function () {
                    var email = $('#loginEmail').val().trim();
                    var password = $('#loginPassword').val().trim();
                    $('#loginErrorMsg').hide().text('');

                    if (email && password) {
                        $.ajax({
                            url: 'Default.aspx/Login',
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({
                                email: email,
                                password: password,
                                rememberMe: $('#rememberMe').is(':checked')
                            }),
                            success: function (response) {
                                if (response.d.Success) {
                                    currentUser = response.d.UserInfo;
                                    updateUIForAuthenticatedUser(currentUser);
                                    closeModal();
                                    loadChats($('.filter-btn.active').data('filter'));
                                    showEmptyChat();
                                    updateStatistics();
                                    handleShareLink();
                                } else {
                                    $('#loginErrorMsg').text(response.d.Error || 'Невірний email або пароль').show();
                                }
                            },
                            error: function () {
                                $('#loginErrorMsg').text('Помилка зв\'язку з сервером').show();
                            }
                        });
                    } else {
                        $('#loginErrorMsg').text('Будь ласка, введіть email та пароль').show();
                    }
                });

                $('#signupSubmitBtn').click(function () {
                    var name = $('#signupName').val().trim();
                    var email = $('#signupEmail').val().trim();
                    var password = $('#signupPassword').val().trim();
                    var confirmPassword = $('#signupPasswordConfirm').val().trim();

                    $('#emailErrorMsg, #passwordErrorMsg').hide().text('');

                    if (!name || !email || !password || !confirmPassword) {
                        $('#passwordErrorMsg').text('Будь ласка, заповніть всі поля').show();
                        return;
                    }
                    if (password !== confirmPassword) {
                        $('#passwordErrorMsg').text('Паролі не співпадають').show();
                        return;
                    }
                    if (!$('#termsAgree').is(':checked')) {
                        $('#passwordErrorMsg').text('Ви повинні погодитись з умовами використання').show();
                        return;
                    }

                    $.ajax({
                        url: 'Default.aspx/Register',
                        type: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            name: name,
                            email: email,
                            password: password,
                            confirmPassword: confirmPassword
                        }),
                        success: function (response) {
                            if (response.d.Success) {
                                closeModal();
                                location.reload();
                            } else {
                                const errorMsg = response.d.Error || 'Помилка реєстрації';
                                if (errorMsg.toLowerCase().includes('email')) {
                                    $('#emailErrorMsg').text(errorMsg).show();
                                } else {
                                    $('#passwordErrorMsg').text(errorMsg).show();
                                }
                            }
                        },
                        error: function () {
                            $('#passwordErrorMsg').text('Помилка зв\'язку з сервером').show();
                        }
                    });
                });

                window.loadPlatformStatistics = loadPlatformStatistics;
                window.updateStatistics = updateStatistics;
                $(document).on('click', '.logout-btn', function () {
                    if (confirm('Ви впевнені, що хочете вийти?')) {
                        $('.logout-btn').html('<i class="fas fa-spinner fa-spin"></i> Вихід...');
                        $.ajax({
                            url: 'Default.aspx/Logout',
                            type: 'POST',
                            contentType: 'application/json',
                            success: function (response) {
                                if (response.d.Success) {
                                    Object.keys(localStorage)
                                        .filter(key => key.startsWith('chatAccess_'))
                                        .forEach(key => localStorage.removeItem(key));
                                    location.reload();
                                } else {
                                    $('.logout-btn').html('<i class="fas fa-sign-out-alt"></i> Вийти');
                                    showNotification('error', 'Помилка при виході: ' + (response.d.Error || 'Невідома помилка'));
                                }
                            },
                            error: function (xhr, status, error) {
                                $('.logout-btn').html('<i class="fas fa-sign-out-alt"></i> Вийти');
                                showNotification('error', 'Помилка зв\'язку з сервером');
                            }
                        });
                    }
                });

                $('#facebookLoginBtn, #facebookSignupBtn').click(function () {
                    window.location.href = 'Default.aspx?provider=Facebook';
                });

                $('#googleLoginBtn, #googleSignupBtn').click(function () {
                    window.location.href = 'Default.aspx?provider=Google';
                });

                var urlParams = new URLSearchParams(window.location.search);
                if (urlParams.has('externalLogin')) {
                    if (urlParams.get('externalLogin') === 'success') {
                        location.reload();
                    } else {
                        $('#loginErrorMsg').text('Помилка входу через соціальну мережу').show();
                        openModal('loginModal');
                    }
                }

                handleShareLink();

                // Notification styles
                if ($('#notificationStyle').length === 0) {
                    $('head').append(`
                        <style id="notificationStyle">
                            .notification {
                                position: fixed;
                                top: 20px;
                                right: 20px;
                                padding: 10px 20px;
                                border-radius: 4px;
                                box-shadow: 0 2px 10px rgba(0,0,0,0.2);
                                z-index: 10000;
                                display: none;
                            }
                            .notification.success {
                                background-color: var(--success-color);
                                color: white;
                            }
                            .notification.error {
                                background-color: var(--danger-color);
                                color: white;
                            }
                            .login-prompt {
                                text-align: center;
                                padding: 30px;
                            }
                            .login-prompt i {
                                font-size: 48px;
                                color: var(--primary-color);
                                margin-bottom: 15px;
                            }
                            .login-prompt-btn {
                                margin-top: 15px;
                            }
                        </style>
                    `);
                }
            }

            function showEmptyChat() {
                var container = $('.messages-container');
                container.empty();
                container.append(
                    '<div class="empty-chat">' +
                    '<i class="fas fa-comments"></i>' +
                    '<h3>Виберіть чат</h3>' +
                    '<p>Виберіть існуючий чат зі списку або створіть новий</p>' +
                    '</div>'
                );

                $('.chat-title i').next().text('Чат не вибрано');
                $('.chat-info').text('Виберіть чат, щоб почати спілкування');
                activeChatId = null;
            }
        </script>
    </form>
</body>
</html>