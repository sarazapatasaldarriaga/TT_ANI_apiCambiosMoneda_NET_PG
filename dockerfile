# Etapa 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
ENV ASPNETCORE_URLS=http://+:5235
EXPOSE 5235

# Copiar los .csproj de todos los proyectos necesarios
COPY ["apiCambiosMoneda.Presentacion/apiCambiosMoneda.Presentacion.csproj", "apiCambiosMoneda.Presentacion/"]
COPY ["apiCambiosMoneda.Dominio/apiCambiosMoneda.Dominio.csproj", "apiCambiosMoneda.Dominio/"]
COPY ["apiCambiosMoneda.Aplicacion/apiCambiosMoneda.Aplicacion.csproj", "apiCambiosMoneda.Aplicacion/"]
COPY ["apiCambiosMoneda.Infraestructura.Repositorio/apiCambiosMoneda.Infraestructura.Repositorio.csproj", "apiCambiosMoneda.Infraestructura/"]

# Restaurar dependencias
RUN dotnet restore "apiCambiosMoneda.Presentacion/apiCambiosMoneda.Presentacion.csproj"

# Copiar el resto del código
COPY . .

# Publicar la API
WORKDIR /src/apiCambiosMoneda.Presentacion
RUN dotnet publish -c Release -o /app/publish

# Etapa 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .



ENTRYPOINT ["dotnet", "apiCambiosMoneda.Presentacion.dll"]
