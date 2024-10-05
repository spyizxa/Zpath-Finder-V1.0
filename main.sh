#!/bin/bash

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Renkleri sıfırla

# Kullanım kontrolü
if [ "$#" -ne 2 ]; then
    echo -e "${RED}Kullanım: $0 <Hedef URL> <Kelime Listesi>${NC}"
    exit 1
fi

URL="$1"
WORDLIST="$2"

# Kelime listesinin varlığını kontrol et
if [ ! -f "$WORDLIST" ]; then
    echo -e "${RED}Kelime listesi bulunamadı: $WORDLIST${NC}"
    exit 1
fi

# Sonuç dosyası
OUTPUT_FILE="found_directories.txt"
echo "Bulunan dizinler:" > "$OUTPUT_FILE"

# Dizin tarama işlemi
echo -e "${YELLOW}Dizin taraması başlatılıyor: $URL${NC}"

# Maksimum eş zamanlı istek sayısı
MAX_CONCURRENT_REQUESTS=20
CURRENT_REQUESTS=0

# İsteği işleyecek fonksiyon
check_url() {
    FULL_URL="$1"
    RESPONSE=$(curl -s -L -o /dev/null -w "%{http_code}" "$FULL_URL")

    echo -e "${BLUE}Denendi:${NC} $FULL_URL - HTTP Durum Kodu: $RESPONSE"

    if [ "$RESPONSE" -eq 200 ]; then
        echo -e "${GREEN}Bulundu:${NC} $FULL_URL"
        echo "$FULL_URL" >> "$OUTPUT_FILE"
    elif [ "$RESPONSE" -eq 301 ]; then
        echo -e "${YELLOW}Yönlendirme:${NC} $FULL_URL"
    elif [ "$RESPONSE" -eq 403 ]; then
        echo -e "${RED}Erişim Engellendi:${NC} $FULL_URL"
    elif [ "$RESPONSE" -eq 404 ]; then
        echo -e "${RED}Bulunamadı:${NC} $FULL_URL"
    else
        echo -e "${RED}Hata:${NC} $FULL_URL - HTTP Durum Kodu: $RESPONSE"
    fi
}

export -f check_url
export URL

# Kelime listesini oku ve asenkron işlemler başlat
cat "$WORDLIST" | xargs -n 1 -P "$MAX_CONCURRENT_REQUESTS" -I {} bash -c "check_url '$URL/{}'; sleep 0.1"

echo -e "${YELLOW}Dizin taraması tamamlandı. Bulunan dizinler ${OUTPUT_FILE} dosyasına kaydedildi.${NC}"