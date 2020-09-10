package main

import (
	"net/http"
)

func main() {
	HttpServerSimple("8080")
}

func serveHTTP(w http.ResponseWriter, _ *http.Request) {
	responseMsg := "Cloud foundry Start..."
	_, _ = w.Write([]byte(responseMsg))
}

func HttpServerSimple(port string) {
	http.HandleFunc("/", serveHTTP)
	_ = http.ListenAndServe(":"+port, nil)
}
