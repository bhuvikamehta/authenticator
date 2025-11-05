# ============================================================
# 🐳 PROVI AUTHENTICATOR - FLUTTER + ANDROID + NDK CONTAINER
# ============================================================

# Base image with Debian and JDK 17
FROM debian:bookworm-slim

# ----------- Version Arguments -----------
ARG FLUTTER_VERSION=3.24.3
ARG ANDROID_SDK_VERSION=11076708_latest
ARG NDK_VERSION=26.2.11394342

# ----------- Environment Variables -----------
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_NDK_HOME=/opt/android-sdk/ndk/${NDK_VERSION}
ENV PATH="$PATH:/opt/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools"

# ----------- System Dependencies -----------
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ----------- Install Flutter SDK -----------
RUN git clone https://github.com/flutter/flutter.git /opt/flutter -b stable \
    && /opt/flutter/bin/flutter doctor -v

# ----------- Install Android SDK Command-Line Tools -----------
RUN mkdir -p /opt/android-sdk/cmdline-tools \
    && cd /opt/android-sdk/cmdline-tools \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}.zip -O commandlinetools.zip \
    && unzip commandlinetools.zip -d /opt/android-sdk/cmdline-tools \
    && rm commandlinetools.zip \
    # Move extracted files into the correct 'latest' folder
    && mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest

# ----------- Update PATH to include SDK tools -----------
ENV PATH="$PATH:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools"

# ----------- Accept Licenses and Install SDK Components -----------
RUN yes | sdkmanager --licenses || true
RUN sdkmanager \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" \
    "ndk;${NDK_VERSION}" \
    "cmake;3.22.1"

# ----------- Configure Flutter for Android -----------
RUN flutter config --android-sdk $ANDROID_HOME
RUN flutter config --enable-web && flutter config --enable-android

# ----------- Copy Project into Container -----------
WORKDIR /app
COPY . .

# ----------- Install Flutter Dependencies -----------
RUN flutter pub get

# ----------- Optional Build (uncomment if needed) -----------
# RUN flutter build apk --debug

# ----------- Expose Port for Flutter Web -----------
EXPOSE 8080

# ----------- Default Command -----------
# Starts Flutter web server by default; change to /bin/bash for dev shell
CMD ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0"]
