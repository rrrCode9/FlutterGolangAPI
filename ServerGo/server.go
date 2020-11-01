package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"github.com/gorilla/mux"
	
)

const port = ":9990"

func main() {

	route := mux.NewRouter()
	route.HandleFunc("/", rootPage)
	route.HandleFunc("/products/{fetchCountPercentage}", products).Methods("GET")

	
	fmt.Println("Link @: http://127.0.0.1" + port)
	log.Fatal(http.ListenAndServe(port, route))
	

}

func rootPage(w http.ResponseWriter, r *http.Request) {

	w.Write([]byte("This is root page"))
}

func products(w http.ResponseWriter, r *http.Request) {

	fetchCountPercentage,errInput := strconv.ParseFloat(mux.Vars(r)["fetchCountPercentage"],64)
	
	fetchCount := 0
	if errInput != nil{
		fetchCount = 0
		fmt.Println(errInput.Error())
		
	}else{
		
		fetchCount = int(float64(len(productList)) * fetchCountPercentage / 100.0)
		if fetchCount>len(productList){fetchCount = len(productList)}
	}
	// fmt.Println(fetchCount)

	js, err := json.Marshal(productList[0:fetchCount])
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)

	} else {

		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Write(js)
	}

}

type product struct {
	Name  string
	Price float64
	Count int
}

var productList = []product{

	product{"gfst", 25.0, 3},
	product{"nbbm", 27.0, 6},
	product{"mjhksk", 45.0, 44},
	product{"jhhsj", 45.0, 44},
	product{"edjhjh", 45.0, 44},
	product{"gtg", 45.0, 644},
	product{"cjk", 45.0, 4},
	product{"ed", 45.0, 44},
	product{"gtg", 45.0, 74},
	product{"cjgjgjk", 45.0, 44},
	


}


