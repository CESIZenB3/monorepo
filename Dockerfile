# Étape 1 : Build avec SDK .NET
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copier uniquement les fichiers nécessaires pour la restauration
COPY CESIZen.sln .
COPY CESIZen/CESIZen.csproj CESIZen/

# Restauration des dépendances
RUN dotnet restore CESIZen.sln

# Copier tout le reste une fois la restore terminée
COPY . .

# Build et publish en Release
WORKDIR /src/CESIZen
RUN dotnet publish -c Release -o /app/publish --no-restore

# Étape 2 : Runtime (image plus légère)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copier les fichiers publiés depuis l'étape build
COPY --from=build /app/publish .

# Exposer les ports (non obligatoire, mais utile en local)
EXPOSE 80
EXPOSE 443

# Démarrage de l'application
ENTRYPOINT ["dotnet", "CESIZen.dll"]
