FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:8.0-alpine as builder

ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM

RUN echo "TARGETPLATFORM: ${TARGETPLATFORM}" && \
    echo "TARGETARCH:     ${TARGETARCH}"     && \
    echo "BUILDPLATFORM:  ${BUILDPLATFORM}"

WORKDIR /source
COPY Worker.csproj .

RUN dotnet restore -a $TARGETARCH

COPY Program.cs .
RUN dotnet publish -c release -o /app -a $TARGETARCH --self-contained false --no-restore

FROM mcr.microsoft.com/dotnet/runtime:8.0-alpine
WORKDIR /app
COPY --from=builder app/ .

CMD ["dotnet", "Worker.dll"]
