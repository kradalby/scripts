package main

import (
    "net/http"
//    "fmt"
    "log"
    "time"
    "io/ioutil"
    "golang.org/x/net/html"
    "os"
)

func main() {
    dagbladetStriper := []string{"lunch", "pondus", "zelda", "nemi"}
    path := os.Args[1]

    for _, c := range dagbladetStriper {
        dagbladet(path, c)
        time.Sleep(4)
    }
}

func checkErr(err error, msg string) {
    if err != nil {
        log.Fatal(err, msg)
    }
}

func dagbladet(path, name string) {
    page := getComicPage("http://www.dagbladet.no/tegneserie/" + name + "/")

    img := getDagbladetStripeUrl(page, name)
    data := downloadStrip(img)

    saveStrip(path, name, data)
}

func getComicPage(url string) *html.Node {
    client := &http.Client{}
    req , err := http.NewRequest("GET", url, nil)

    req.Close = true

    resp, err := client.Do(req)
    if err != nil {
        resp, err = client.Do(req)
    }

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
    client := &http.Client{}
    req , err := http.NewRequest("GET", url, nil)

    req.Close = true

    resp, err := client.Do(req)

    data, err := ioutil.ReadAll(resp.Body)
    checkErr(err, "Download failed")
    defer resp.Body.Close()

    return data
}

func saveStrip(path, name string, data []byte) {
    now := time.Now().Format("2006-Jan-02")
    fileName := name + "_" + now + ".png"

    err := ioutil.WriteFile(path + "/" + fileName, data, 0755)
    checkErr(err, "IO write file failed")

    log.Printf("%s saved successfully\n", fileName)
}
