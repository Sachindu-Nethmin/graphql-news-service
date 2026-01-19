import ballerina/graphql;
import ballerina/lang.runtime;
import ballerina/random;

listener graphql:Listener graphqlListener = new (8080);

// Storage for all published news
News[] newsStorage = [];

@graphql:ServiceConfig {
    graphiql: {
        enabled: true
    }
}
service /news on graphqlListener {

    string[] headlines = [
        "Breaking: New Technology Revolutionizes Industry",
        "Local Hero Saves Community Center",
        "Scientists Discover Breakthrough in Medicine",
        "Economy Shows Strong Growth This Quarter",
        "Environmental Initiative Gains Momentum"
    ];
    
    string[] contents = [
        "In a surprising turn of events, experts are amazed by the latest developments.",
        "Community members gathered to celebrate this remarkable achievement.",
        "Researchers have been working tirelessly to bring this innovation to life.",
        "Market analysts predict continued positive trends in the coming months.",
        "Citizens and organizations unite for a sustainable future."
    ];
    remote function publishNews(string Headline, string Content) returns News {
        News newNews = {
            Headline: Headline,
            Content: Content
        };
        newsStorage.push(newNews);
        return newNews;
    }

    resource function get allNews() returns News[] {
        return newsStorage;
    }

    resource function subscribe randomNews() returns stream<News, error?> {
        NewsGenerator newsGenerator = new (self.headlines, self.contents);
        stream<News, error?> newsStream = new (newsGenerator);
        return newsStream;
    }
}

class NewsGenerator {
    private final string[] headlines;
    private final string[] contents;
    private int count = 0;
    private final int maxCount = 10;

    isolated function init(string[] headlines, string[] contents) {
        self.headlines = headlines;
        self.contents = contents;
    }

    // The `next` method picks random headline and content from the lists and returns a News item.
    // Returns () after generating maxCount items to complete the stream.
    public isolated function next() returns record {|News value;|}|error? {
        if self.count >= self.maxCount {
            return ();
        }
        
        // Sleep for 1 second to simulate a delay.
        runtime:sleep(1);
        int headlineIndex = check random:createIntInRange(0, self.headlines.length());
        int contentIndex = check random:createIntInRange(0, self.contents.length());
        News randomNews = {
            Headline: self.headlines[headlineIndex],
            Content: self.contents[contentIndex]
        };
        self.count += 1;
        return {value: randomNews};
    }
}
