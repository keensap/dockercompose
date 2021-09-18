#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim AS base
WORKDIR /app

EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0-buster-slim AS build
WORKDIR /src

COPY ["dockercompose.api/dockercompose.api.csproj", "dockercompose.api/"]
RUN dotnet restore "dockercompose.api/dockercompose.api.csproj"
COPY . .
WORKDIR "/src/dockercompose.api"

RUN dotnet build "dockercompose.api.csproj" -c Release -o /app/build

ENV ASPNETCORE_ENVIRONMENT="DEVELOPMENT"

FROM build AS publish
RUN dotnet publish "dockercompose.api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN mkdir -p Logs
ENTRYPOINT ["dotnet", "dockercompose.api.dll"]