package main

import (
	"fmt"
	"os"
)

func main() {
	env1 := os.Getenv("ENV1")
	env2 := os.Getenv("ENV2")
	fmt.Println(env1)
	fmt.Println(env2)
}
