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

    string[] names = ["Walter White", "Jesse Pinkman", "Saul Goodman"];
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

    resource function subscribe randomNews() returns stream<string, error?> {
        NameGenerator nameGenerator = new (self.names);
        // Create a stream using the `NameGenerator` object.
        stream<string, error?> names = new (nameGenerator);
        return names;
    }
}

class NameGenerator {
    private final string[] names;

    isolated function init(string[] names) {
        self.names = names;
    }

    // The `next` method picks a random name from the list and returns it.
    public isolated function next() returns record {|string value;|}|error? {
        // Sleep for 1 second to simulate a delay.
        runtime:sleep(1);
        int index = check random:createIntInRange(0, self.names.length());
        return {value: self.names[index]};
    }
}
