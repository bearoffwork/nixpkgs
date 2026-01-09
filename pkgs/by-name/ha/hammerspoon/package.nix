{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk_15,
  xcbuildHook,
  python3,
  git,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hammerspoon";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Hammerspoon";
    repo = "hammerspoon";
    rev = finalAttrs.version;
    hash = "sha256-HEEkn1f0BNZZz8m2ZKfmfuklBoH8c2Mi+zhbC5rbCFw=";
  };

  nativeBuildInputs = [
    xcbuildHook
    python3
    git
  ];

  buildInputs = [
    apple-sdk_15
  ];

  __structuredAttrs = true;

  xcbuildFlags = [
    "-workspace"
    "Hammerspoon.xcworkspace"
    "-scheme"
    "Hammerspoon"
    "-configuration"
    "Release"
    "CODE_SIGN_IDENTITY=-"
    "CODE_SIGNING_ALLOWED=YES"
    "CODE_SIGNING_REQUIRED=NO"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    # xcbuildHook builds to ./Products/Release by default
    if [ -d "Products/Release/Hammerspoon.app" ]; then
      cp -r Products/Release/Hammerspoon.app $out/Applications/
    else
      # Fallback: search for the app
      find . -name "Hammerspoon.app" -type d -print0 | head -1 | xargs -0 -I {} cp -r {} $out/Applications/
    fi

    runHook postInstall
  '';

  meta = {
    description = "Staggeringly powerful macOS desktop automation with Lua";
    homepage = "https://www.hammerspoon.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bearoffwork ];
    platforms = lib.platforms.darwin;
  };
})
