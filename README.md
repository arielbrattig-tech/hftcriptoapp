# HFTCripto — página de cupom

Landing page estática (HTML/CSS/JS, sem dependências) empacotada em um container
nginx pronto para rodar em qualquer nuvem.

```
index.html                       a página
Dockerfile                       imagem nginx
nginx/default.conf.template      config do servidor (porta via ${PORT})
.github/workflows/               build da imagem e deploy no Pages
```

## Rodar localmente

```bash
docker build -t cupom .
docker run --rm -p 8080:8080 cupom
```

Acesse <http://localhost:8080>.

Para testar em outra porta, basta passar a variável:

```bash
docker run --rm -e PORT=3000 -p 3000:3000 cupom
```

## Publicar na nuvem

A imagem escuta na porta definida pela variável de ambiente `PORT` (padrão
`8080`), que é o contrato usado pela maioria das plataformas. Há também um
endpoint `/healthz` que responde `200 ok` para os health checks.

### Google Cloud Run

```bash
gcloud run deploy cupom --source . --region us-central1 --allow-unauthenticated
```

### Render / Railway / Koyeb

Conecte o repositório do GitHub e escolha o tipo **Docker**. O `Dockerfile` na
raiz é detectado automaticamente e a plataforma injeta a `PORT`.

### Fly.io

```bash
fly launch --dockerfile Dockerfile
fly deploy
```

### Usando a imagem já publicada no GitHub

O workflow publica a imagem no GitHub Container Registry a cada push na `main`:

```bash
docker pull ghcr.io/arielbrattig-tech/hftcriptoapp:latest
```

Ela nasce privada. Para usá-la em uma plataforma externa, torne o pacote público
em **Repositório → Packages → Package settings → Change visibility**, ou
configure as credenciais do registry na plataforma.

## Atualizar a página

Edite o `index.html`, faça commit e push. O workflow reconstrói a imagem; em
seguida, faça o redeploy na plataforma escolhida (Render, Railway e Cloud Run
podem ser configurados para redeploy automático).

O HTML é servido com `Cache-Control: no-cache`, ou seja, é sempre revalidado —
uma alteração aparece para o visitante no acesso seguinte, sem cache preso.

## Alternativa sem Docker

Por ser uma página estática, ela também roda de graça no **GitHub Pages**
(Settings → Pages → Deploy from branch → `main` / root), sem container nem
servidor. O Docker vale a pena quando você quer controle sobre cabeçalhos,
domínio próprio e portabilidade entre nuvens.
