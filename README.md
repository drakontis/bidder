## Overview
This is a simple bidder application. It receives a POST request, in the endpoint */bid*, from an external Ad-Exchange system asking for a bid submission for one of its campaigns.
When the bidder receives the request, it searches for a *winner* campaign in order to submit a bid for this campaign. After this process, the application responds to the initial request either with a bid submission and status code 200 if a winner campaign was found, or without a bid and status code 204 if no winner campaign was found.
The selection of the applicable campaigns is based on the campaigns’ *targeted countries*, meaning that a campaign could be considered *applicable* if the country that is included in the body of the *bid request* is also included in the campaign’s *targeted countries* list. Another constraint is that there should not exist more than 100 submissions per minute for each campaign. The winner campaign is the one with the biggest price.

The application was built using the language Ruby v2.2.8 and the web framework Ruby On Rails v4.1.8 and is fully unit tested using the Rspec testing framework.


## Architecture
The models related to the bid are put under the module ‘*Bid*’.
The campaign model is not inside a module because it is very simple and can be considered as a module itself. If the campaign entity is about to get more complicated, it should be put inside in a separate module.
The above decision was taken considering the [YAGNI](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it) principle.

The POST request from the external Ad-Exchange system is routed in the *BidRequestsController* in the action create.

Each *bid submission* is stored in a table called *bid_submissions*, in the database. The submissions are being stored in order to be available for past submissions searching. A huge amount of *bid_submissions* entries may cause a performance degradation in the database. A possible approach to avoid this degradation incident is the usage of a background worker, that will wake up in specific times, archive somewhere (e.g. Amazon S3) the old entries of the *bid_submissions* table and then remove them from the database.


## Usage
To run the application you should have the following software installed:
* Postgresql RDBMS
  * [Installation Instructions](http://postgresguide.com/setup/install.html)
* RVM (Ruby Version Manager)
  * [Installation Instructions](https://rvm.io/rvm/install)
* Ruby v2.2.8
  * To Install ruby just type in a console:

```rvm install ruby-2.2.8```

When the required software is installed, visit the project’s root folder (if you are already there just type cd .) and type:

```rvm current```

You should see something like this:

```ruby-2.2.8@bidder```

Then you need to install the bundler gem. In the project’s root folder type:

```gem install bundler```

Now you are ready to install all the external libraries (gems). To do this in the project’s root folder type:

```bundle install```

(This could take a while.)

Now let’s configure the database.
* Rename the config/database.yml.sample to config/database.yml and in the development section set the username and password for the Postgresql user.
* Create the database and run the schema migrations by typing the two following commands:

```
rake db:create
rake db:migrate
```

If you want to recreate the database run the following commands:

```
rake db:drop
rake db:create
rake db:migrate
```

Now you are ready to start your server. In the project’s root folder type:

```
rails s
```

You should see that the server is running.

Voila! You are ready to request a new bid.


## Tests
The application is fully unit tested and also includes some functional tests, to ensure that the integration between the application’s components is working.
To run the whole test suite from the project’s root folder just type:

```
rspec spec
```


## Test application in development environment
In order to check the application in the **development** environment, you can mock the campaign API by replacing the body of the class method *fetch_campaigns*, found in the file ‘app/models/campaign.rb’, with the following code:

(**Attention**: This action is applicable only for the **development** environment and not for the **test** environment.)

```
response = '[
        {
            "id": "5a3dce46",
            "name": "Test Campaign 1",
            "price": 1.23,
            "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
            "targetedCountries": [
                "USA",
                "GBR",
                "GRC"
            ]
        },
        {
            "id": "c56bc77b",
            "name": "Test Campaign 2",
            "price": 0.45,
            "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
            "targetedCountries": [
                "BRA",
                "EGY"
            ]
        },
        {
            "id": "a20579a5",
            "name": "Test Campaign 3",
            "price": 2.21,
            "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
            "targetedCountries": [
                "HUN",
                "MEX"
            ]
        },
        {
            "id": "e919799e",
            "name": "Test Campaign 4",
            "price": 0.39,
            "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
            "targetedCountries": [
                "USA"
            ]
        },
        {
            "id": "ef88888f",
            "name": "Test Campaign 5",
            "price": 1.6,
            "adm": "<a href=\"http://example.com/click/qbFCjzXR9rkf8qa4\"><img src=\"http://assets.example.com/ad_assets/files/000/000/002/original/banner_300_250.png\" height=\"250\" width=\"300\" alt=\"\"/></a><img src=\"http://example.com/win/qbFCjzXR9rkf8qa4\" height=\"1\" width=\"1\" alt=\"\"/>\r\n",
            "targetedCountries": [
                "GBR"
            ]
        }
    ]'

    JSON.parse response
```
