# news Integration

Add your integration description here.

subscription{
  randomNews{
    Headline
    Content
  }
}

mutation {
  publishNews(Content: "", Headline: "") {
    Content
    Headline
  }
}

{
  allNews {
    Content
    Headline
  }
}