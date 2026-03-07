#!/usr/bin/env bash
set -e

TUIST_VERSION="4.33.0"

echo "[1] Tuist 버전 확인 중..."
if command -v tuist &> /dev/null; then
    CURRENT_TUIST_VERSION=$(tuist version | cut -d. -f1)
    if [ "$CURRENT_TUIST_VERSION" -lt 4 ]; then
        echo "[1-1] 구버전(4 미만) Tuist 감지: 제거를 진행합니다."
        curl -Ls https://uninstall.tuist.io | bash
    else
        echo "[1-1] Tuist 버전이 $CURRENT_TUIST_VERSION.x 이므로 제거를 건너뜁니다."
    fi
else
    echo "[1-1] Tuist가 설치되어 있지 않아 제거할 필요가 없습니다."
fi

echo "[2] mise 설치 확인 중..."
if [ ! -f "$HOME/.local/bin/mise" ]; then
    echo "[2-1] mise가 설치되어 있지 않습니다. 설치를 진행합니다."
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "[2-1] mise가 이미 설치되어 있습니다."
fi

echo "[3] mise 활성화 여부 확인 중..."
if ! grep -q 'eval "$(~/.local/bin/mise activate zsh)"' ~/.zshrc; then
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
    echo "[3-1] ~/.zshrc에 mise 활성화 스크립트를 추가했습니다."
else
    echo "[3-1] 이미 ~/.zshrc에 mise 활성화 스크립트가 있습니다."
fi

echo "[4] Tuist 버전 설정..."
"$HOME/.local/bin/mise" install tuist@"$TUIST_VERSION"
"$HOME/.local/bin/mise" use -g tuist@"$TUIST_VERSION"
