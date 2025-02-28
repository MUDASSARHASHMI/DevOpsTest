package main

import (
	"fmt"
	"net/http"
	"time"
)

func getCurrentTime(w http.ResponseWriter, r *http.Request) {
	currentTime := time.Now()
	fmt.Fprintf(w, "Current Date and Time: %s", currentTime.Format(time.RFC3339))
}

func main() {
	http.HandleFunc("/time", getCurrentTime)
	fmt.Println("Server starting on port 8080...")
	http.ListenAndServe(":8080", nil)
}
