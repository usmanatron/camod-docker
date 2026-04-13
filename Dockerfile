FROM mcr.microsoft.com/dotnet/runtime:6.0.36

ARG CA_VERSION

RUN apt update && \
    apt install --no-install-recommends -y python3 unzip curl jq && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /camod

RUN curl -fsSL -o camod.zip https://github.com/Inq8/CAmod/releases/download/1.08.2/CombinedArms-${CA_VERSION}-x64-winportable.zip && \
    unzip camod.zip && \
    rm camod.zip && \
    # Grab mod.config and re-point engine
    curl -fsSL -o mod.config https://raw.githubusercontent.com/Inq8/CAmod/refs/tags/${CA_VERSION}/mod.config && \
    sed -i 's|ENGINE_DIRECTORY=.*|ENGINE_DIRECTORY="/camod"|' mod.config && \
    # Update RuntimeConfig - use the runtime provided by the container
    jq '.runtimeOptions.framework = .runtimeOptions.includedFrameworks[0] | del(.runtimeOptions.includedFrameworks)' OpenRA.Server.runtimeconfig.json > temp.json && \
    mv temp.json OpenRA.Server.runtimeconfig.json

COPY --chmod=0755 launch-dedicated.sh /camod/launch.sh

EXPOSE 1234
CMD ["/camod/launch.sh"]
