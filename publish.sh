#!/usr/bin/env bash
# IBC 2026 보고서 → GitHub Pages 배포
# 사용법: 이 폴더에서  bash publish.sh
set -e

REPO="ibc2026-report"
USER="Jeffkim2021"

echo "==> 1. Git 초기화"
git init -b main
git add -A
git commit -m "IBC 2026 참관 보고서"

echo
echo "==> 2. 원격 저장소 생성 및 푸시"
if command -v gh >/dev/null 2>&1; then
  # GitHub CLI가 있으면 저장소 생성 + Pages 활성화까지 자동
  gh repo create "$USER/$REPO" --public --source=. --remote=origin --push
  gh api -X POST "repos/$USER/$REPO/pages" \
    -f "source[branch]=main" -f "source[path]=/" 2>/dev/null \
    || echo "   (Pages가 이미 켜져 있거나 수동 설정이 필요합니다)"
else
  echo "   gh CLI가 없습니다. github.com에서 '$REPO' 저장소를 먼저 만든 뒤:"
  git remote add origin "https://github.com/$USER/$REPO.git"
  git push -u origin main
  echo "   → Settings > Pages > Source: main / (root) 로 설정"
fi

echo
echo "==> 완료. 1~2분 후 아래 주소에서 확인하십시오."
echo "    https://${USER,,}.github.io/$REPO/"
