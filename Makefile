# Directory to store local binaries in
BIN_PATH := $(CURDIR)/bin

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
  SHASUM := sha256sum -c
  SED := sed -i
  BITWARDEN_URL := https://github.com/bitwarden/cli/releases/download/v1.18.1/bw-linux-1.18.1.zip
  BITWARDEN_HASH := E8713B1D0D75F41C5077BBBCB81FBC6536D95CDF919F702FE23A66ECDAE979DD
  JQ_URL := https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  JQ_HASH := af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44
endif

export BITWARDENCLI_APPDATA_DIR=$(BIN_PATH)/bitwarden_config

build:
	./build.sh

start:
	./start.sh

bw_login: $(BIN_PATH)/bw
	$(BIN_PATH)/bw login --apikey

bw_unlock: $(BIN_PATH)/bw
	$(BIN_PATH)/bw unlock

bw_sync: $(BIN_PATH)/bw
	$(BIN_PATH)/bw sync

bw_download: $(BIN_PATH)/bw $(BIN_PATH)/jq
	$(BIN_PATH)/bw get item docker-compose-tailscale | $(BIN_PATH)/jq --raw-output '.notes' > ./secrets/tailscale.env

clean_dependencies:
	rm -rf $(BIN_PATH)

install_dependencies: $(BIN_PATH)/bw $(BIN_PATH)/jq

$(BIN_PATH)/bw:
	mkdir -p $(BIN_PATH)
	rm -rf $(BIN_PATH)/.bitwarden $$BITWARDENCLI_APPDATA_DIR
	mkdir -p $(BIN_PATH)/.bitwarden
	curl --fail -sL -o $(BIN_PATH)/.bitwarden.zip "$(BITWARDEN_URL)"
	echo "$(BITWARDEN_HASH)  $(BIN_PATH)/.bitwarden.zip" | $(SHASUM)
	unzip $(BIN_PATH)/.bitwarden.zip -d $(BIN_PATH)/.bitwarden
	mv $(BIN_PATH)/.bitwarden/bw $(BIN_PATH)/bw
	chmod +x $(BIN_PATH)/bw
	rm -rf $(BIN_PATH)/.bitwarden $(BIN_PATH)/.bitwarden.zip

$(BIN_PATH)/jq:
	mkdir -p $(BIN_PATH)
	curl --fail -sL -o $(BIN_PATH)/jq "$(JQ_URL)"
	echo "$(JQ_HASH)  $(BIN_PATH)/jq" | $(SHASUM)
	chmod +x $(BIN_PATH)/jq
