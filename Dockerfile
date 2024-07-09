# Selecionando a imagem que será utilizada no projeto
# e criando a seperação dos estagios do deploy
FROM golang:1.22.4-alpine as builder

#Criando a pasta onde irá trabalhar
WORKDIR /app

# Copiando arquivos de configuração para a wordir
COPY go.mod go.sum ./

# Instalando as libs e as configurações do projeto
RUN go mod download && go mod verify

# Copiando a aplicação
COPY . .

# Criando arquivo de build e 
# utilizando o "-o" para direcionar o arquivo criado
RUN go build -o /bin/journey ./cmd/journey/journey.go


# Separação em stages para utilizar apenas o necessário em prod
FROM scratch

WORKDIR /app

COPY --from=builder /bin/journey .

#Comando para expor uma porta
EXPOSE 8080

# Ponto de entrada do container
ENTRYPOINT [ "./journey" ]