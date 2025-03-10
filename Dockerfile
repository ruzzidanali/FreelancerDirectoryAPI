# Use official ASP.NET Core runtime as base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use SDK image to build app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["FreelancerDirectoryAPI.csproj", "./"]
RUN dotnet restore "./FreelancerDirectoryAPI.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "./FreelancerDirectoryAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "./FreelancerDirectoryAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FreelancerDirectoryAPI.dll"]
