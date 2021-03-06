FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY *.csproj ./
RUN dotnet restore
COPY . ./
WORKDIR "/src/DockerTest"
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app	
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "DockerTest.dll"]