terraform {
    required_providers {
        vkcs = {
            source = "vk-cs/vkcs"
            version = "< 1.0.0"
        }
    }
}

provider "vkcs" {
    # Your user account.
    username = "olegzhi007@gmail.com"

    # The password of the account
    password = "Fccfcby20!"

    # The tenant token can be taken from the project Settings tab - > API keys.
    # Project ID will be our token.
    project_id = "47ab3c57c62147bba4d202de139e3ec9"
    
    # Region name
    region = "RegionOne"
    
    auth_url = "https://infra.mail.ru:35357/v3/" 
}
