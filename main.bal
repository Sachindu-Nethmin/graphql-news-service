import ballerina/graphql;
import ballerina/lang.runtime;

listener graphql:Listener graphqlListener = new (8080);

// Storage for all published news
News[] newsStorage = [];

@graphql:ServiceConfig {
    graphiql: {
        enabled: true
    }
}
service /news on graphqlListener {

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
        NewsGenerator newsGenerator = new (newsStorage);
        stream<News, error?> newsStream = new (newsGenerator);
        return newsStream;
    }
}

class NewsGenerator {
    private final News[] newsItems;
    private int index = 0;

    isolated function init(News[] newsItems) {
        self.newsItems = newsItems.cloneReadOnly();
    }

    // The `next` method returns news items from the storage one by one.
    // Returns () after all items have been streamed.
    public isolated function next() returns record {|News value;|}|error? {
        if self.index >= self.newsItems.length() {
            return ();
        }
        
        // Sleep for 1 second to simulate a delay.
        runtime:sleep(1);
        News currentNews = self.newsItems[self.index];
        self.index += 1;
        return {value: currentNews};
    }
}
