package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

type Task struct {
	ID          int    `json:"id"`
	Title       string `json:"title"`
	IsCompleted bool   `json:"is_completed"`
}

var db *sql.DB

func main() {
	var err error
	// Koneksi ke MySQL Laragon
	db, err = sql.Open("mysql", "root:@tcp(127.0.0.1:3306)/task_db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	http.HandleFunc("/tasks", handleTasks)

	log.Println("Server backend berjalan di port 8080...")
	// Menggunakan 0.0.0.0 agar server bisa diakses oleh perangkat lain (HP) dalam satu WiFi
	log.Fatal(http.ListenAndServe("0.0.0.0:8080", nil))
}

func handleTasks(w http.ResponseWriter, r *http.Request) {
	// Mengatur agar response berupa JSON dan mengizinkan akses dari aplikasi mobile (CORS)
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == "GET" {
		rows, err := db.Query("SELECT id, title, is_completed FROM tasks")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var tasks []Task = []Task{}
		for rows.Next() {
			var t Task
			rows.Scan(&t.ID, &t.Title, &t.IsCompleted)
			tasks = append(tasks, t)
		}
		json.NewEncoder(w).Encode(tasks)
		return
	}

	if r.Method == "POST" {
		var newTask Task
		err := json.NewDecoder(r.Body).Decode(&newTask)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		result, err := db.Exec("INSERT INTO tasks (title, is_completed) VALUES (?, ?)", newTask.Title, false)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		id, _ := result.LastInsertId()
		newTask.ID = int(id)
		json.NewEncoder(w).Encode(newTask)
		return
	}
}