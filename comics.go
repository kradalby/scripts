package main

import (
    "net/http"
//    "fmt"
    "log"
    "time"

    "io/ioutil"
    "golang.org/x/net/html"
)

func main() {
    dagbladetStriper := []string{"lunch", "pondus", "zelda", "nemi"}

    for _, c := range dagbladetStriper {
        page := getComicPage("http://www.dagbladet.no/tegneserie/" + c + "/")

        img := getDagbladetStripeUrl(page, c)
        log.Println(img)
        data := downloadStrip(img)

        saveStrip(c, data)
    }
}

func checkErr(err error, msg string) {
    if err != nil {
        log.Fatal(err, msg)
    }
}

func getComicPage(url string) *html.Node {
    resp, err := http.Get(url)

    //checkErr(err, "Failed to fetch url: " + url)

    parsedHtml, err := html.Parse(resp.Body)
    checkErr(err, "Failed to parse html")
    defer resp.Body.Close()


    return parsedHtml
}

func getDagbladetStripeUrl(n *html.Node, name string) string {
    var img string
    if n.Type == html.ElementNode && n.Data == "img" {
        for _, a := range n.Attr {
            if a.Key == "id" && a.Val == name + "-stripe" {
                img = n.Attr[2].Val
                return img
            }
        }
    }
    for c := n.FirstChild; c != nil; c = c.NextSibling {
        img = getDagbladetStripeUrl(c, name)
        if img != "" {
            return img
        }
    }
    return img
}

func downloadStrip(url string) []byte {
    resp, _ := http.Get(url)

    data, err := ioutil.ReadAll(resp.Body)
    checkErr(err, "Download failed")
    defer resp.Body.Close()

    return data
}

func saveStrip(name string, data []byte) {
    now := time.Now().Format("2006-Jan-02")
    fileName := name + "_" + now + ".png"

    err := ioutil.WriteFile(fileName, data, 0755)
    checkErr(err, "IO write file failed")

    log.Printf("%s saved successfully\n", fileName)
}
