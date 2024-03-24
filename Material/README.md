# DevPoli Challenge

Agradecemos sua participação no Desafio DevPoli! Estamos animados para ver sua criatividade e habilidades em ação.

## Descrição

O Desafio DevPoli é uma oportunidade para você demonstrar suas habilidades de desenvolvimento e resolver problemas interessantes. Cada desafio é projetado para fornecer uma experiência de aprendizado prática e divertida, onde você poderá desenvolver projetos inspiradores.

Aproveite este desafio para aprimorar suas habilidades e se destacar como desenvolvedor mobile. Para acessar mais desafios e expandir ainda mais seu conhecimento, confira outros desafios disponíveis na [DevPoli](https://devpoli.com/challenges).

## Instruções

Você deve desenvolver um aplicativo com foco na construção das telas de Login e Cadastro do usuário com autenticação social.

Esse desafio é uma sequência do [Sign In & Up](https://devpoli.com/challenges/signin-signup). Você pode desenvolvê-lo completamente do zero, adicionando todas as funcionalidades, ou optar por evoluir o projeto anterior. Caso escolha a evolução, recomendamos criar um fork para dar continuidade.
 
Siga as instruções abaixo para completar o desafio:

### Tela de Sign In:

- Crie a tela de Sign In para validar o acesso do usuário.
- O usuário deve informar o email e senha para realizar o login.
- Use o email `meu@email.com` e senha `Teste@123` para validar o acesso.
- Ao clicar em Esqueci a senha, verifique se o email está informado no campo.
- Exiba um alerta com a mensagem "Enviamos um e-mail para recuperação de senha".
- Se o campo de email estiver vazio ou com um email inválido, exiba um alerta com a mensagem "Informe o e-mail para continuar".
- Ao fechar o alerta, o campo de email deve ser focado e o teclado aberto.

### Login Social:

- Adicione a funcionalidade de Login Social, onde o usuário pode vincular sua conta com outras plataformas como Facebook, Apple ID ou outros de sua escolha.
- Ao clicar no botão social, você deve realizar o processo de verificação de conta.
- Utilize um framework ou faça a autenticação individual para verificar a conta do usuário com o integrador escolhido.
- Ao realizar o login com sucesso, redirecione o usuário para a tela inicial do aplicativo.

### Tela de Sign Up:

- Crie a tela de Sign Up para capturar as informações do usuário.
- Os campos (Primeiro nome, último nome, email, senha e confirmação de senha) são obrigatórios.
- Faça as validações de email válido, senha com no mínimo 5 caracteres e a confirmação de senha correspondendo à senha informada.
- O botão Criar Conta só deve ficar habilitado quando todos os campos estiverem preenchidos corretamente.
- Ao clicar no botão, exiba um alerta de sucesso informando que o cadastro foi realizado com sucesso e retorne para a tela de login.

### Termos e Condições:

- Ao clicar na label "termos e condições de uso", abra uma webview interna em sua aplicação para o site [DevPoli](https://devpoli.com).

### Observações:

- Não é necessário realizar a persistência dos dados.
- Sinta-se à vontade para utilizar frameworks como o Firebase para facilitar o trabalho de autenticação.
- Ao fazer login com as informações corretas, você pode direcionar para uma tela customizada de sua preferência ou exibir um alerta.
    
## Material

As imagens necessárias estão na pasta `Material/Icons`.

## Solução

Quando terminar de codar a sua obra-prima, é hora de brilhar! Acesse o desafio no site da [DevPoli](https://devpoli.com/challenges) e compartilhe a sua criação com a nossa comunidade animada! Estamos ansiosos para ver o que você construiu! 🚀😄

## Precisa de ajuda?

Acesso nosso [Fórum](https://devpoli.com/forum/devpoli-challenge) para receber suporte, compartilhar conhecimento e esclarecer dúvidas sobre o desafio.


## Licença

Este desafio é fornecido sob a [Licença MIT](https://opensource.org/licenses/MIT). Sinta-se à vontade para usar, modificar e distribuir o código resultante conforme os termos da licença.
