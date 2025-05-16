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
- path (manipulação de caminhos de arquivo) 
- Flutter Secure Storage (armazenamento de dados de login)  
- intl (validação de data)  

---

## ⚙️ Como Executar

1. **Pré-requisitos**
   - Flutter SDK (≥ 3.0)  
   - Android Studio / VS Code  
   - Emulador ou dispositivo físico Android/iOS

2. **Clone o repositório**
   ```bash
   git clone https://github.com/Derkein/test_dev_mobile
   cd test_dev_mobile
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
  - Usuário: teste.mobile
  - Senha: 1234

  ---