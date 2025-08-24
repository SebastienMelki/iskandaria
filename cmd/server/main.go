package main

import (
	"fmt"
	songv1 "github.com/SebastienMelki/iskandaria/api/contracts/song/v1"
)

func main() {
	fmt.Println("Hello World")
	_ = songv1.GetSongsRequest{SongIdList: nil}
}
