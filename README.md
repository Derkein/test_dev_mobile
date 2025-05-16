# Mundo Wap Task App

Um protótipo de app Flutter para o desafio técnico da Mundo Wap, implementando autenticação, lista de tarefas e formulário de respostas com persistência local.

---

## 📝 Descrição

Este projeto demonstra:

- **Tela de Login** com usuário e senha (_mock_ de API).
- **Área Logada** exibindo nome, perfil e lista de tarefas recebidas da API.
- **Marcação de tarefas** concluídas e pendentes.
- **Formulário de Tarefa** com campos dinâmicos (texto, preço, data), validação e salvamento.
- **Autosave** do formulário ao app ir para segundo plano.
- **Persistência local** em SQLite (`task_responses`, `completed_tasks`, `form_state`).
- **Reset do banco** local a partir da tela de login.
- **Theming** centralizado (cores, tipografia, botões, campos).

---

## 🚀 Funcionalidades

- **Autenticação**  
  - Usuário: `teste.mobile`  
  - Senha: `1234`  
  - Dados simulados via `LoginRepository` (pode ser facilmente adaptado para chamada real à API).

- **Lista de Tarefas**  
  - Exibe tarefas com indicador de status (círculo cinza/verde + `check`).
  - Pull-to-refresh para recarregar dados.

- **Formulário de Resposta**  
  - Campos gerados dinamicamente conforme `field_type`:  
    - `text` → entrada de texto livre  
    - `mask_price` → formatação de moeda (R\$)  
    - `mask_date` → formatação de data (DD/MM/AAAA)  
  - Validações de campo obrigatório, formato de data.
  - Salva cada resposta em SQLite e marca tarefa como concluída.
  - Recupere automaticamente respostas salvas e estado parcial do formulário.

- **Persistência Local**  
  - `AppDatabase` cria e gerencia três tabelas:  
    - `task_responses`  
    - `completed_tasks`  
    - `form_state`  
  - `TaskRepository` encapsula todas as operações de CRUD.

- **Reset de Banco**  
  - Botão “RESETAR BANCO LOCAL” na tela de login para apagar o banco e recriá-lo, é necessário interromper a execução (stop) e iniciar o app novamente para que o banco seja recriado corretamente.

- **Theming**  
  - Cores e estilos definidos em `AppTheme`.

---

## 🛠 Tecnologias

- Flutter & Dart  
- Provider (injeção de dependências e gerenciamento de estado)  
- SQFlite (SQLite local)  
- Flutter Secure Storage (armazenamento de dados de login)  
- intl (validação de data)  

---

## 📁 Estrutura de Pastas
lib/
├── core/
│   ├── database/
│   │   └── app_database.dart        # Inicia e configura o SQLite
│   └── utils/
│       └── input_formatters.dart    # Máscaras de preço e data
│
├── data/
│   ├── models/
│   │   ├── field_model.dart
│   │   ├── task_model.dart
│   │   ├── task_response_model.dart
│   │   └── user_model.dart
│   └── repositories/
│       ├── login_repository.dart    # Mock de API + SecureStorage
│       └── task_repository.dart     # CRUD em SQLite
│
├── presentation/
│   ├── screens/
│   │   ├── login/
│   │   │   ├── login_view.dart
│   │   │   ├── login_controller.dart
│   │   │   └── login_state.dart
│   │   ├── home/
│   │   │   ├── home_view.dart
│   │   │   ├── home_controller.dart
│   │   │   └── home_state.dart
│   │   └── tasks/
│   │       ├── task_form_view.dart
│   │       ├── task_form_controller.dart
│   │       └── task_form_state.dart
│   │
│   ├── widgets/
│   │   ├── loading_overlay.dart     # Overlay de loading
│   │   └── task_item.dart           # Card de tarefa
│   │
│   └── theme/
│       └── app_theme.dart           # Cores e estilos globais
│
└── main.dart                        # Entry point + Providers

---

## ⚙️ Como Executar

1. **Pré-requisitos**
   - Flutter SDK (≥ 3.0)  
   - Android Studio / VS Code  
   - Emulador ou dispositivo físico Android/iOS

2. **Clone o repositório**
   ```bash
   git clone https://github.com/seu-usuario/mundo-wap-task-app.git
   cd mundo-wap-task-app
   ```

3. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

4. **Rode o aplicativo:**
   ```bash
   flutter run
   ```

5. **Login:**
  Usuário: teste.mobile
  Senha: 1234

  ---