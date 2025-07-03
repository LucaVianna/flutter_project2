# 🍏 Nectar - E-commerce de Supermercado Online

Um aplicativo de e-commerce completo e funcional, construído com Flutter e Firebase. Este projeto simula uma loja de supermercado online, com funcionalidades tanto para clientes quanto para administradores.

## ✨ Funcionalidades Implementadas

O aplicativo conta com dois papéis de usuário (Cliente e Administrador), com funcionalidades específicas para cada um.

### 👤 Para Clientes
-   **Autenticação Completa:** Cadastro, Login e Logout seguros com Firebase Authentication.
-   **Catálogo de Produtos Dinâmico:** Visualização de produtos em tempo real, lidos diretamente do Firestore.
-   **Carrinho de Compras:** Adicionar, remover e alterar a quantidade de itens com gerenciamento de estado centralizado via Provider.
-   **Sistema de Cupons com Câmera:** Possibilidade de escanear um QR Code para validar e aplicar cupons de desconto no carrinho.
-   **Histórico de Pedidos:** Tela para visualizar todos os pedidos feitos, com status atualizados em tempo real.
-   **Cancelamento de Pedidos:** O usuário pode cancelar um pedido enquanto o status ainda estiver "Pendente".
-   **Gerenciamento de Conta:** Edição de dados do perfil e exclusão permanente da conta.
-   **Notificações Locais:** O usuário é notificado no dispositivo sempre que o status de um de seus pedidos é alterado pelo administrador.

### 🛡️ Para Administradores
-   **Visão de Admin:** Acesso a menus e telas exclusivas, visíveis apenas para usuários com permissão de administrador.
-   **CRUD Completo de Produtos:**
    -   **Create:** Adicionar novos produtos à loja através de um formulário no app.
    -   **Read:** Visualizar **todos** os produtos (ativos e inativos).
    -   **Update:** Editar todas as informações de um produto, incluindo seu status (ativo/inativo).
    -   **Delete:** Remover permanentemente um produto do catálogo.
-   **Gerenciamento de Pedidos:** Visualizar a lista completa de **todos os pedidos de todos os usuários** e alterar o status de cada um (Pendente, Enviado, Entregue, Cancelado).

## 🛠️ Tecnologias e Arquitetura

Este projeto foi construído utilizando as melhores práticas do ecossistema Flutter e Firebase.

-   **Framework:** Flutter
-   **Linguagem:** Dart
-   **Backend:** Firebase (Authentication, Cloud Firestore)
-   **Arquitetura:**
    -   **Clean Architecture (Simplificada):** Separação clara do projeto em camadas: `core` (código compartilhado), `data` (acesso a dados) e `features` (UI e estado da UI).
    -   **Feature-First:** Organização de arquivos por funcionalidade (admin, auth, home).
-   **Gerenciamento de Estado:**
    -   `Provider` para injeção de dependência e gerenciamento de estado.
    -   `ChangeNotifier` para os estados da UI.
    -   `ChangeNotifierProxyProvider` para criar providers que dependem de outros (ex: `OrderProvider` dependendo de `AuthProvider`).
-   **Reatividade:** Uso de `Streams` (`.snapshots()`) do Firestore para garantir que a UI reflita o estado do banco de dados em tempo real.
-   **Principais Pacotes:**
    -   `provider`
    -   `cloud_firestore` & `firebase_auth`
    -   `mobile_scanner` (para o leitor de QR Code)
    -   `flutter_local_notifications`
    -   `intl` (para formatação de datas)

## 🚀 Como Rodar Este Projeto

Para executar este aplicativo em sua máquina local, você precisará configurar o ambiente Flutter e conectá-lo a um projeto Firebase.

### Pré-requisitos

-   Flutter SDK instalado.
-   Uma conta no Firebase.
-   Android Studio ou VS Code.

### Passos de Configuração

1.  **Clone o Repositório**
    ```bash
    git clone [URL_DESTE_REPOSITORIO]
    cd [NOME_DA_PASTA_DO_PROJETO]
    ```

2.  **Instale as Dependências**
    ```bash
    flutter pub get
    ```

3.  **Configuração do Firebase**
    Como o arquivo `firebase_options.dart` não está no repositório por segurança, você precisará conectá-lo ao seu próprio projeto Firebase.

    a. Crie um projeto no [console do Firebase](https://console.firebase.google.com/).

    b. Instale a CLI do Firebase (`npm install -g firebase-tools`) e a do FlutterFire (`dart pub global activate flutterfire_cli`).

    c. Rode o comando de configuração na raiz do seu projeto e siga as instruções:
    ```bash
    flutterfire configure
    ```
    Isso irá gerar o arquivo `firebase_options.dart` para você.

4.  **Habilite os Serviços e Configure as Regras de Segurança**
    a. **Habilite os Serviços:** No console do seu projeto Firebase, certifique-se de habilitar os seguintes serviços:
    -   **Authentication:** Vá em "Authentication" -> "Sign-in method" e habilite a opção **"E-mail/Senha"**.
    -   **Cloud Firestore:** Vá em "Cloud Firestore", clique em "Criar banco de dados" e inicie no **modo de produção** (production mode), pois vamos definir nossas próprias regras.

    b. **Atualize as Regras de Segurança:** Na aba **Regras (Rules)** do Cloud Firestore, substitua todo o conteúdo pelas seguintes regras e clique em **Publicar**:
    ```javascript
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {

        // Regra para a coleção 'users'
        match /users/{userId} {
          allow read, update, delete: if request.auth != null && request.auth.uid == userId;
          allow create: if request.auth != null;
        }

        // Regra para a coleção 'orders'
        match /orders/{orderId} {
          allow read: if request.auth != null &&
                         (request.auth.uid == resource.data.userId ||
                          get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
          allow write: if request.auth != null &&
                          (request.auth.uid == request.resource.data.userId ||
                           get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true);
        }
        
        // Regra para a coleção 'products'
        match /products/{productId} {
          allow read: if request.auth != null;
          allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
        }

        // Regra para a coleção 'coupons'
        match /coupons/{couponId} {
            allow read: if request.auth != null;
            allow write: if false; 
        }
      }
    }
    ```

5.  **Rode o Aplicativo**
    ```bash
    flutter run
    ```
    *Lembre-se de criar um usuário e, no console do Firestore, alterar o campo booleano `isAdmin: true` no documento dele para testar as funcionalidades de administrador. Lembre-se também de criar um documento na coleção 'coupons', preencher seus campos (code=PROMO20, discountValue=20, type=percentage, isActive=true) e gerar um QR Code (via sites online) para testar o sistema de cupons com câmera.*

## 📈 Próximos Passos (Roadmap Futuro)

-   [ ] Implementar o cálculo de frete baseado na localização do usuário (GPS + API do Google Maps).
-   [ ] Adicionar upload de imagens para os produtos através do app, usando o Firebase Storage.
-   [ ] Criar um sistema de avaliação (estrelas e comentários) para os produtos.

## 👤 Autor

**Luca Vianna Martins Silveira**