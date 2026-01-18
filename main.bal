import ballerina/graphql;

listener graphql:Listener graphqlListener = new (8080);

// Storage for all published news
News[] newsStorage = [];

service /news on graphqlListener {
    remote function publishNews(string Headline, string Content) returns PublishedNews {
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
}
