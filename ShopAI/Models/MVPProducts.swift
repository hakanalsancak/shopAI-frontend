//
//  MVPProducts.swift
//  Zokey
//
//  Static product recommendations for MVP demo
//  Maps subcategoryId + optionId → product name + affiliate link
//

import Foundation

struct MVPProduct {
    let name: String
    let url: String
}

struct MVPResultItem: Identifiable {
    let id = UUID()
    let product: MVPProduct?
}

struct MVPProductData {
    static func getProduct(subcategoryId: String, optionId: String) -> MVPProduct? {
        return products[subcategoryId]?[optionId]
    }

    // MARK: - All Products

    private static let products: [String: [String: MVPProduct]] = [

        // =============================================
        // ELECTRONICS & COMPUTERS
        // =============================================

        // Camera & Photo
        "camera-photo": [
            "dslr": MVPProduct(name: "Canon EOS 2000D DSLR Camera", url: "https://amzn.to/4axRgKE"),
            "mirrorless": MVPProduct(name: "Sony Alpha a6400 Mirrorless Camera", url: "https://amzn.to/3ZJHHnd"),
            "compact": MVPProduct(name: "Canon PowerShot SX740 HS", url: "https://amzn.to/4731D8m"),
            "action": MVPProduct(name: "GoPro HERO11 Black", url: "https://amzn.to/3MBaqHO"),
            "instant": MVPProduct(name: "Fujifilm Instax Mini 12", url: "https://amzn.to/46eqRAr"),
        ],

        // TV & Home Cinema
        "tv-home-cinema": [
            "tv": MVPProduct(name: "Samsung 55\" Crystal UHD 4K TV", url: "https://amzn.to/4tHHjDv"),
            "projector": MVPProduct(name: "BenQ TH671ST Full HD Projector", url: "https://amzn.to/4aZvL6W"),
            "soundbar": MVPProduct(name: "Sonos Beam (Gen 2)", url: "https://amzn.to/4tHHGhn"),
            "hometheater": MVPProduct(name: "Hisense AX5100Q 5.1 Home Theatre System", url: "https://amzn.to/4cFkIRH"),
        ],

        // Audio & HiFi
        "audio-hifi": [
            "speakers": MVPProduct(name: "JBL Charge 5 Portable Speaker", url: "https://amzn.to/4auVaoY"),
            "amplifier": MVPProduct(name: "Sony STR-DH190 Stereo Amplifier", url: "https://amzn.to/4c5Ig1T"),
            "turntable": MVPProduct(name: "Audio-Technica AT-LP60X", url: "https://amzn.to/4c5wTHm"),
            "receiver": MVPProduct(name: "Denon AVR-X1800H", url: "https://amzn.to/3MwA14F"),
            "smartspeaker": MVPProduct(name: "Amazon Echo Dot (Newest Gen)", url: "https://amzn.to/4b1205G"),
        ],

        // Headphones
        "headphones": [
            "overear": MVPProduct(name: "Sony WH-1000XM5", url: "https://amzn.to/3ZMDuPy"),
            "onear": MVPProduct(name: "JBL Tune 510BT", url: "https://amzn.to/4rUyYKK"),
            "inear": MVPProduct(name: "Sony WI-C100", url: "https://amzn.to/4s0aWOs"),
            "tws": MVPProduct(name: "Apple AirPods Pro (2nd Gen)", url: "https://amzn.to/46lT1cS"),
        ],

        // Sat Nav & Car Electronics
        "sat-nav-car": [
            "satnav": MVPProduct(name: "Garmin DriveSmart 65", url: "https://amzn.to/4rCIm63"),
            "dashcam": MVPProduct(name: "Nextbase 522GW", url: "https://amzn.to/3OpjDDE"),
            "carstereo": MVPProduct(name: "Pioneer MVH-S320BT", url: "https://amzn.to/3OqyspC"),
            "carcharger": MVPProduct(name: "Anker Car Charger 30W", url: "https://amzn.to/4atMe3j"),
        ],

        // Phones & Accessories
        "phones-accessories": [
            "smartphone": MVPProduct(name: "Apple iPhone 15", url: "https://amzn.to/3ZMFnfc"),
            "case": MVPProduct(name: "Spigen Ultra Hybrid iPhone Case", url: "https://amzn.to/4rCItyv"),
            "charger": MVPProduct(name: "Anker Nano USB-C Charger", url: "https://amzn.to/3MBbKug"),
            "screenprotector": MVPProduct(name: "JETech Tempered Glass Protector", url: "https://amzn.to/4tNDLzl"),
            "powerbank": MVPProduct(name: "Anker PowerCore 20000", url: "https://amzn.to/4qR3y7g"),
        ],

        // PC & Video Games
        "pc-video-games": [
            "ps5": MVPProduct(name: "Sony PlayStation 5 Console Digital Slim", url: "https://amzn.to/4s5jLqw"),
            "xbox": MVPProduct(name: "Xbox Series X", url: "https://amzn.to/3ZMEmUk"),
            "switch": MVPProduct(name: "Nintendo Switch OLED", url: "https://amzn.to/3MTF8Mj"),
            "pc": MVPProduct(name: "HP Pavilion Gaming Desktop", url: "https://amzn.to/4aBRUs9"),
        ],

        // Laptops
        "laptops": [
            "general": MVPProduct(name: "Acer Aspire 5", url: "https://amzn.to/4qN2AZK"),
            "work": MVPProduct(name: "Dell XPS 13", url: "https://amzn.to/4u1Alt8"),
            "creative": MVPProduct(name: "MacBook Pro 14-inch", url: "https://amzn.to/4rZWOF1"),
            "gaming": MVPProduct(name: "ASUS ROG Strix G15", url: "https://amzn.to/4cEIsp5"),
            "coding": MVPProduct(name: "Lenovo ThinkPad X1 Carbon", url: "https://amzn.to/3ZMYqG4"),
        ],

        // Tablets
        "tablets": [
            "any": MVPProduct(name: "Samsung Galaxy Tab A8", url: "https://amzn.to/4s6sGrM"),
            "apple": MVPProduct(name: "iPad 11-inch: A16 chip", url: "https://amzn.to/3MVyBkh"),
            "samsung": MVPProduct(name: "Galaxy Tab S9", url: "https://amzn.to/3OE7RFr"),
            "amazon": MVPProduct(name: "Fire HD 10", url: "https://amzn.to/4rWtijl"),
        ],

        // Desktops
        "desktops": [
            "general": MVPProduct(name: "HP All-in-One Desktop", url: "https://amzn.to/4rt8RLj"),
            "gaming": MVPProduct(name: "Alienware Aurora ACT1250", url: "https://amzn.to/4tHJebb"),
            "work": MVPProduct(name: "Dell OptiPlex 7010", url: "https://amzn.to/4cB4kBF"),
            "creative": MVPProduct(name: "Apple Mac Studio", url: "https://amzn.to/4tNqcQm"),
        ],

        // Monitors
        "monitors": [
            "general": MVPProduct(name: "Dell 24\" Full HD Monitor", url: "https://amzn.to/470qv0q"),
            "gaming": MVPProduct(name: "ASUS TUF VG27AQ", url: "https://amzn.to/3ML8c8C"),
            "creative": MVPProduct(name: "LG UltraFine 27\"", url: "https://amzn.to/4aMUNVT"),
            "office": MVPProduct(name: "HP E24 G5", url: "https://amzn.to/4aGQH1n"),
        ],

        // Memory & Storage
        "memory-storage": [
            "ssd": MVPProduct(name: "Samsung 970 EVO Plus", url: "https://amzn.to/4s5kGas"),
            "hdd": MVPProduct(name: "Seagate BarraCuda 2TB", url: "https://amzn.to/4s1vBBQ"),
            "external": MVPProduct(name: "WD My Passport 2TB", url: "https://amzn.to/4s7ws49"),
            "usb": MVPProduct(name: "SanDisk Ultra Flair 128GB", url: "https://www.amazon.co.uk/s?k=SanDisk+Ultra+Flair+128GB"),
            "sdcard": MVPProduct(name: "SanDisk Extreme Pro SDXC", url: "https://amzn.to/4tLW4F3"),
        ],

        // Networking Devices
        "networking": [
            "router": MVPProduct(name: "TP-Link Archer AX55", url: "https://amzn.to/4b0a1YF"),
            "mesh": MVPProduct(name: "Google Nest WiFi", url: "https://amzn.to/4asQWy9"),
            "extender": MVPProduct(name: "TP-Link RE550", url: "https://amzn.to/4atF8vG"),
            "switch": MVPProduct(name: "NETGEAR 8-Port Gigabit Switch", url: "https://amzn.to/4b0I9nh"),
        ],

        // Computer Accessories
        "computer-accessories": [
            "keyboard": MVPProduct(name: "Logitech MX Keys", url: "https://amzn.to/3Oj4dkm"),
            "mouse": MVPProduct(name: "Logitech MX Master 3S", url: "https://amzn.to/3ZMGQCe"),
            "webcam": MVPProduct(name: "Logitech C920", url: "https://amzn.to/4qR52hQ"),
            "hub": MVPProduct(name: "Anker 7-in-1 USB-C Hub", url: "https://amzn.to/3MkVBsT"),
            "stand": MVPProduct(name: "Nulaxy Adjustable Stand", url: "https://amzn.to/4c6l9UX"),
        ],

        // Computer Components
        "computer-components": [
            "gpu": MVPProduct(name: "NVIDIA RTX 5070", url: "https://amzn.to/46DhlHp"),
            "cpu": MVPProduct(name: "AMD Ryzen 7 5800X", url: "https://amzn.to/4tMjeeD"),
            "ram": MVPProduct(name: "Corsair Vengeance LPX 2x16GB", url: "https://amzn.to/3MPqcil"),
            "motherboard": MVPProduct(name: "MSI B550 Tomahawk", url: "https://amzn.to/4b1qtrG"),
            "psu": MVPProduct(name: "Corsair RM750x", url: "https://amzn.to/4b10a4P"),
            "case": MVPProduct(name: "NZXT H5 Flow", url: "https://amzn.to/46ke4MS"),
        ],

        // Software
        "software": [
            "office": MVPProduct(name: "Microsoft 365 Personal", url: "https://amzn.to/4tGjWtL"),
            "security": MVPProduct(name: "Norton 360 Deluxe", url: "https://amzn.to/46etRgb"),
            "creative": MVPProduct(name: "Adobe Photoshop", url: "https://amzn.to/4b14sco"),
            "os": MVPProduct(name: "Windows 11 Home", url: "https://amzn.to/3OqAnKQ"),
        ],

        // Printers & Ink
        "printers-ink": [
            "inkjet": MVPProduct(name: "HP DeskJet 4220e", url: "https://amzn.to/40hjd4O"),
            "laser": MVPProduct(name: "Brother HL-L2400DWE", url: "https://amzn.to/4qLnTuE"),
            "photo": MVPProduct(name: "Canon PIXMA PRO-200", url: "https://amzn.to/40ljBiI"),
            "allinone": MVPProduct(name: "Epson EcoTank ET-2850", url: "https://amzn.to/4qNBlOu"),
        ],

        // =============================================
        // HOME, GARDEN & DIY
        // =============================================

        // Kitchen & Home Appliances
        "kitchen-appliances": [
            "kettle": MVPProduct(name: "Russell Hobbs Electric Kettle", url: "https://amzn.to/4qLOOq0"),
            "toaster": MVPProduct(name: "Breville 2-Slice Toaster", url: "https://amzn.to/4s3qv8d"),
            "blender": MVPProduct(name: "NutriBullet 600", url: "https://amzn.to/4rW0Tdb"),
            "coffee": MVPProduct(name: "Nespresso Vertuo Plus", url: "https://amzn.to/4tRrJVW"),
            "airfryer": MVPProduct(name: "Ninja Dual Zone", url: "https://amzn.to/4rT95Le"),
            "microwave": MVPProduct(name: "Panasonic NN-ST48", url: "https://amzn.to/4kOTTwH"),
        ],

        // Large Appliances
        "large-appliances": [
            "fridge": MVPProduct(name: "Bosch Serie 2", url: "https://amzn.to/4qLGzKy"),
            "washing": MVPProduct(name: "Samsung Series 5", url: "https://amzn.to/3MFhdQA"),
            "dryer": MVPProduct(name: "Beko Heat Pump Dryer", url: "https://amzn.to/3ZIj9uN"),
            "dishwasher": MVPProduct(name: "Bosch Serie 4", url: "https://amzn.to/40hkg4K"),
            "oven": MVPProduct(name: "Hotpoint Built-In Oven", url: "https://amzn.to/4s3zlCR"),
        ],

        // Cooking & Dining
        "cooking-dining": [
            "cookware": MVPProduct(name: "Tefal Ingenio Set", url: "https://amzn.to/4rTDVnc"),
            "cutlery": MVPProduct(name: "Amazon Basics Cutlery Set", url: "https://amzn.to/40kPpnT"),
            "dinnerware": MVPProduct(name: "Corelle 16-Piece Set", url: "https://amzn.to/4tMDvRg"),
            "glassware": MVPProduct(name: "LAV Highball Glass", url: "https://amzn.to/4kLo33R"),
            "utensils": MVPProduct(name: "Joseph Joseph Utensil Set", url: "https://amzn.to/4atmWlU"),
        ],

        // Furniture
        "furniture": [
            "sofa": MVPProduct(name: "HomeTown Market Durable Fabric Sofa", url: "https://amzn.to/3MGN2bU"),
            "bed": MVPProduct(name: "Emma Original Bed", url: "https://amzn.to/4tKJztl"),
            "table": MVPProduct(name: "IKEA LISABO", url: "https://amzn.to/4qSv7x1"),
            "chair": MVPProduct(name: "SIHOO M59AS Ergonomic Office Chair", url: "https://amzn.to/3OsLQt8"),
            "storage": MVPProduct(name: "IKEA KALLAX", url: "https://amzn.to/4ruAu6F"),
            "desk": MVPProduct(name: "IKEA MICKE", url: "https://amzn.to/4qIqIfT"),
        ],

        // Bedding & Linens
        "bedding-linens": [
            "duvet": MVPProduct(name: "Silentnight 10.5 Tog", url: "https://amzn.to/4b5pmX1"),
            "sheets": MVPProduct(name: "Elegant Comfort Luxury Soft 1500 Premier Egyptian 4-Piece", url: "https://amzn.to/3MFih72"),
            "pillows": MVPProduct(name: "Tempur Original Pillow", url: "https://amzn.to/40pJgXq"),
            "mattress": MVPProduct(name: "Emma Original Mattress", url: "https://amzn.to/4rUDl8C"),
            "towels": MVPProduct(name: "Amazon Basics Towel Set", url: "https://amzn.to/4rykH6M"),
        ],

        // Home Accessories
        "home-accessories": [
            "decor": MVPProduct(name: "Umbra Decorative Vase", url: "https://amzn.to/4c5EIwK"),
            "mirrors": MVPProduct(name: "Beauty4U Full Length Mirror 194x94cm", url: "https://amzn.to/4aGV2lb"),
            "rugs": MVPProduct(name: "Safavieh Area Rug", url: "https://amzn.to/3OqynlE"),
            "curtains": MVPProduct(name: "Amazon Basics Blackout Curtains", url: "https://amzn.to/3OzWn5O"),
            "frames": MVPProduct(name: "Nielsen Gallery Frame Set", url: "https://amzn.to/3OqCo9S"),
        ],

        // Arts, Crafts & Sewing
        "arts-crafts": [
            "art": MVPProduct(name: "Castle Art Supplies Set", url: "https://amzn.to/4tM32db"),
            "craft": MVPProduct(name: "Cricut Starter Bundle", url: "https://amzn.to/46ew5w3"),
            "sewing": MVPProduct(name: "Singer Heavy Duty Sewing Machine", url: "https://amzn.to/4aJfIZE"),
            "knitting": MVPProduct(name: "Lion Brand Yarn Set", url: "https://amzn.to/40iKS5l"),
        ],

        // Garden & Outdoors
        "garden-outdoors": [
            "furniture": MVPProduct(name: "Keter Outdoor Furniture Set", url: "https://amzn.to/4kNFOj0"),
            "plants": MVPProduct(name: "Flower Seed Box Bumper Pack", url: "https://amzn.to/46YONba"),
            "mower": MVPProduct(name: "Bosch Rotak Lawn Mower", url: "https://amzn.to/4aqZWE2"),
            "bbq": MVPProduct(name: "Weber Compact Kettle Grill", url: "https://amzn.to/4qXMnkA"),
            "decor": MVPProduct(name: "Solar Garden Lights Set", url: "https://amzn.to/40mqWhY"),
        ],

        // Power, Garden & Hand Tools
        "power-tools": [
            "drill": MVPProduct(name: "DeWalt Cordless Drill", url: "https://amzn.to/46lY2SK"),
            "saw": MVPProduct(name: "Bosch Circular Saw", url: "https://amzn.to/4s3Bbnf"),
            "sander": MVPProduct(name: "Makita Orbital Sander", url: "https://amzn.to/4737BGi"),
            "hand": MVPProduct(name: "Stanley Tool Set", url: "https://amzn.to/4tJHxK2"),
            "toolkit": MVPProduct(name: "Amazon Basics Tool Kit", url: "https://amzn.to/46SuXyn"),
        ],

        // Kitchen & Bathroom Fixtures
        "kitchen-bathroom-fixtures": [
            "taps": MVPProduct(name: "Grohe Chrome Mixer Tap", url: "https://amzn.to/4kHrZlW"),
            "shower": MVPProduct(name: "Mira Electric Shower", url: "https://amzn.to/3MIxnbX"),
            "toilet": MVPProduct(name: "Roca Close-Coupled Toilet", url: "https://amzn.to/4cEMZI7"),
            "sink": MVPProduct(name: "Reginox Stainless Steel Sink", url: "https://amzn.to/4kOl4HJ"),
            "bath": MVPProduct(name: "iBathUK Standard Square Single Ended Bath", url: "https://amzn.to/4cbf61z"),
        ],

        // Trade & Professional Tools
        "professional-tools": [
            "electrical": MVPProduct(name: "Fluke Multimeter", url: "https://amzn.to/3ZMxWEQ"),
            "plumbing": MVPProduct(name: "Rothenberger Pipe Tool Set", url: "https://amzn.to/3ZN3kCY"),
            "carpentry": MVPProduct(name: "Bosch Professional Tool Kit", url: "https://amzn.to/3ZRc238"),
            "general": MVPProduct(name: "DeWalt Combo Tool Kit", url: "https://amzn.to/46L997O"),
        ],

        // Smart Home
        "smart-home": [
            "speaker": MVPProduct(name: "Amazon Echo Dot", url: "https://amzn.to/4tTHE67"),
            "thermostat": MVPProduct(name: "Google Nest Thermostat", url: "https://amzn.to/3OqAaHo"),
            "lights": MVPProduct(name: "Philips Hue Starter Kit", url: "https://amzn.to/4asVe8J"),
            "camera": MVPProduct(name: "Ring Indoor Cam", url: "https://amzn.to/3OqEczG"),
            "doorbell": MVPProduct(name: "Ring Video Doorbell", url: "https://amzn.to/4kIFjXc"),
            "lock": MVPProduct(name: "August Smart Lock", url: "https://amzn.to/4aJ91a2"),
        ],

        // Lighting
        "lighting": [
            "ceiling": MVPProduct(name: "LED Ceiling Light Fixture", url: "https://amzn.to/3MG5xwY"),
            "lamp": MVPProduct(name: "IKEA HEKTAR Lamp", url: "https://amzn.to/46hKMOS"),
            "outdoor": MVPProduct(name: "Solar Outdoor Lights", url: "https://amzn.to/4rB3OZm"),
            "led": MVPProduct(name: "Govee LED Strip Lights", url: "https://amzn.to/3Othirh"),
            "bulbs": MVPProduct(name: "Philips LED Bulbs", url: "https://amzn.to/46jh6B7"),
        ],

        // Pet Supplies (first question: "What pet?")
        "pet-supplies": [
            "dog": MVPProduct(name: "Pedigree Dog Food", url: "https://amzn.to/3ZJ6RCp"),
            "cat": MVPProduct(name: "Whiskas Cat Food", url: "https://amzn.to/4c0kMv8"),
            "bird": MVPProduct(name: "Kaytee Bird Seed", url: "https://amzn.to/4rx0YEC"),
            "fish": MVPProduct(name: "Tetra Fish Tank Starter Kit", url: "https://amzn.to/4c7u3Sg"),
            "small": MVPProduct(name: "Vitakraft Small Animal Food", url: "https://amzn.to/4qTgFov"),
        ],

        // =============================================
        // TOYS, CHILDREN & BABY
        // =============================================

        // Toys & Games (first question: "Child's age group?")
        "toys-games": [
            "toddler": MVPProduct(name: "Fisher-Price Laugh & Learn Puppy", url: "https://amzn.to/3MAvePI"),
            "preschool": MVPProduct(name: "LEGO DUPLO Starter Set", url: "https://amzn.to/3ZJV32L"),
            "kids": MVPProduct(name: "LEGO City Police Station", url: "https://amzn.to/3MVHcDw"),
            "tweens": MVPProduct(name: "NERF Elite Blaster", url: "https://amzn.to/3ZNQIeQ"),
            "teens": MVPProduct(name: "Monopoly Classic", url: "https://amzn.to/4tK2Rza"),
        ],

        // Baby
        "baby": [
            "feeding": MVPProduct(name: "Philips Avent Bottle Set", url: "https://amzn.to/4auCKot"),
            "nappies": MVPProduct(name: "Pampers Baby-Dry", url: "https://amzn.to/4asipA5"),
            "pushchair": MVPProduct(name: "Joie Nitro Stroller", url: "https://amzn.to/4kLywfv"),
            "cot": MVPProduct(name: "IKEA SNIGLAR Cot", url: "https://amzn.to/46dd2lS"),
            "carseat": MVPProduct(name: "Maxi-Cosi Pebble Pro", url: "https://amzn.to/3Os2UQ7"),
            "monitor": MVPProduct(name: "VTech Video Baby Monitor", url: "https://amzn.to/4rz8S08"),
        ],

        // Kids' & Baby Fashion (first question: "Age group?")
        "kids-baby-fashion": [
            "newborn": MVPProduct(name: "Baby Bodysuit Set", url: "https://amzn.to/3MC3lXu"),
            "baby": MVPProduct(name: "Cotton Baby Outfit Set", url: "https://amzn.to/4tRXq1i"),
            "toddler": MVPProduct(name: "Toddler Jacket", url: "https://amzn.to/4b0mjQK"),
            "kids": MVPProduct(name: "Kids Hoodie Set", url: "https://amzn.to/4tUwqOL"),
        ],

        // =============================================
        // CLOTHES, SHOES & WATCHES
        // =============================================

        // Women
        "women": [
            "dresses": MVPProduct(name: "ZARA Midi Dress", url: "https://amzn.to/4aKwrvE"),
            "tops": MVPProduct(name: "D&H Cotton Top", url: "https://amzn.to/4u5ExrV"),
            "jeans": MVPProduct(name: "Levi's 501", url: "https://amzn.to/4cASzeA"),
            "shoes": MVPProduct(name: "Clarks Leather Flats", url: "https://amzn.to/4rvLtNh"),
            "bags": MVPProduct(name: "Michael Kors Tote", url: "https://amzn.to/46P9dDu"),
            "watches": MVPProduct(name: "Daniel Wellington Watch", url: "https://amzn.to/4tKAmkU"),
        ],

        // Men
        "men": [
            "shirts": MVPProduct(name: "Calvin Klein Slim Shirt", url: "https://amzn.to/3OrVmwQ"),
            "tshirts": MVPProduct(name: "Nike Cotton T-Shirt", url: "https://amzn.to/4rvLzED"),
            "jeans": MVPProduct(name: "Levi's 511", url: "https://amzn.to/4s0HsA3"),
            "shoes": MVPProduct(name: "Adidas Stan Smith", url: "https://amzn.to/3OpenzW"),
            "suits": MVPProduct(name: "Hugo Boss Suit", url: "https://amzn.to/46fTCwD"),
            "watches": MVPProduct(name: "Casio G-Shock", url: "https://amzn.to/4c5NElN"),
        ],

        // Boys
        "boys": [
            "tops": MVPProduct(name: "Boys Graphic T-Shirt", url: "https://amzn.to/4aEpaxr"),
            "trousers": MVPProduct(name: "Boys Denim Jeans", url: "https://amzn.to/4aKOqCr"),
            "shoes": MVPProduct(name: "Boys Trainers", url: "https://amzn.to/4s0HwzN"),
            "outerwear": MVPProduct(name: "Boys Winter Jacket", url: "https://amzn.to/3OrVD2Q"),
        ],

        // Girls
        "girls": [
            "dresses": MVPProduct(name: "Girls Party Dress", url: "https://amzn.to/3MHJSoj"),
            "tops": MVPProduct(name: "Girls Cotton Top", url: "https://amzn.to/3MIbpWv"),
            "trousers": MVPProduct(name: "Girls Leggings", url: "https://amzn.to/4tOyqaY"),
            "shoes": MVPProduct(name: "Girls Ballet Flats", url: "https://amzn.to/4s1AT04"),
            "outerwear": MVPProduct(name: "Girls Winter Coat", url: "https://amzn.to/4cCypkj"),
        ],

        // Baby (Fashion)
        "fashion-baby": [
            "bodysuits": MVPProduct(name: "Baby Bodysuit Pack", url: "https://amzn.to/4s39vir"),
            "sleepsuits": MVPProduct(name: "Baby Sleepsuit Set", url: "https://amzn.to/3ZO5C4Q"),
            "outfits": MVPProduct(name: "Baby Outfit Set", url: "https://amzn.to/4rv0XRC"),
            "shoes": MVPProduct(name: "Baby Soft Sole Shoes", url: "https://amzn.to/46jHMBG"),
        ],

        // Luggage
        "luggage": [
            "suitcase": MVPProduct(name: "Samsonite Large Suitcase", url: "https://amzn.to/46kCTZ1"),
            "carry-on": MVPProduct(name: "Cabin Spinner Case", url: "https://amzn.to/4b2MYfS"),
            "backpack": MVPProduct(name: "Osprey Travel Backpack", url: "https://amzn.to/4azeCzy"),
            "duffel": MVPProduct(name: "Nike Duffel Bag", url: "https://amzn.to/3MmjpfZ"),
        ],

        // =============================================
        // SPORTS & OUTDOORS
        // =============================================

        // Sports & Outdoor Clothing
        "sports-clothing": [
            "tops": MVPProduct(name: "Nike Dri-FIT Top", url: "https://amzn.to/4aREKpQ"),
            "bottoms": MVPProduct(name: "Adidas Training Shorts", url: "https://amzn.to/4qN58a8"),
            "jackets": MVPProduct(name: "Under Armour Sports Jacket", url: "https://amzn.to/4rsfnlc"),
            "outdoor": MVPProduct(name: "Columbia Waterproof Jacket", url: "https://amzn.to/4rnTcg4"),
        ],

        // Sports & Outdoor Shoes
        "sports-shoes": [
            "running": MVPProduct(name: "Nike Air Zoom Pegasus", url: "https://amzn.to/4rXpr5z"),
            "training": MVPProduct(name: "Reebok Nano", url: "https://amzn.to/4rozjFL"),
            "hiking": MVPProduct(name: "Merrell Moab 3", url: "https://amzn.to/3MpHDpE"),
            "football": MVPProduct(name: "Adidas Predator", url: "https://amzn.to/3MGEMbK"),
        ],

        // Fitness
        "fitness": [
            "weights": MVPProduct(name: "Amazon Basics Dumbbell Set", url: "https://amzn.to/4aEmsYQ"),
            "cardio": MVPProduct(name: "Reebok Exercise Bike", url: "https://amzn.to/3ZL9cNd"),
            "yoga": MVPProduct(name: "Liforme Yoga Mat", url: "https://amzn.to/3MCEXFa"),
            "resistance": MVPProduct(name: "FitBeast Bands", url: "https://amzn.to/4cGZB1j"),
            "tracker": MVPProduct(name: "Fitbit Charge 6", url: "https://amzn.to/4c7HX6L"),
        ],

        // Camping & Hiking
        "camping-hiking": [
            "tent": MVPProduct(name: "Vango 2-Person Tent", url: "https://amzn.to/4s4ZVvr"),
            "sleepingbag": MVPProduct(name: "Coleman Sleeping Bag", url: "https://amzn.to/3Ou1ODl"),
            "backpack": MVPProduct(name: "Deuter Backpack", url: "https://amzn.to/4kXubGb"),
            "cookware": MVPProduct(name: "Camping Cookware Set", url: "https://amzn.to/4b0GDBv"),
            "lighting": MVPProduct(name: "LED Camping Lantern", url: "https://amzn.to/4kXugJZ"),
        ],

        // Cycling
        "cycling": [
            "bike": MVPProduct(name: "Huffy Mountain Bike", url: "https://amzn.to/4cM1ObM"),
            "helmet": MVPProduct(name: "Giro Cycling Helmet", url: "https://amzn.to/4c60JeT"),
            "clothing": MVPProduct(name: "Cycling Jersey Set", url: "https://amzn.to/4qKlfFz"),
            "accessories": MVPProduct(name: "Bike Tool Kit", url: "https://amzn.to/4qQyzYX"),
        ],

        // Sports Technology
        "sports-tech": [
            "watch": MVPProduct(name: "Garmin Forerunner", url: "https://amzn.to/4c7SFKv"),
            "tracker": MVPProduct(name: "Fitbit Inspire", url: "https://amzn.to/4qNpRKQ"),
            "hrm": MVPProduct(name: "Polar H10", url: "https://amzn.to/3OAjBJ1"),
            "gps": MVPProduct(name: "Garmin GPS Device", url: "https://amzn.to/472O8FH"),
        ],

        // Water Sports
        "water-sports": [
            "swimming": MVPProduct(name: "Speedo Swim Goggles", url: "https://amzn.to/4b2A69t"),
            "surfing": MVPProduct(name: "Foam Surfboard", url: "https://amzn.to/4s3Deb4"),
            "kayak": MVPProduct(name: "Inflatable Kayak", url: "https://amzn.to/4kN9tIQ"),
            "diving": MVPProduct(name: "Snorkel Set", url: "https://amzn.to/40lMPOn"),
        ],

        // Winter Sports
        "winter-sports": [
            "skiing": MVPProduct(name: "Ski Set", url: "https://amzn.to/4tVgzPZ"),
            "snowboarding": MVPProduct(name: "Snowboard", url: "https://amzn.to/3OvjqyI"),
            "clothing": MVPProduct(name: "Thermal Ski Jacket", url: "https://amzn.to/4kMVwLh"),
            "accessories": MVPProduct(name: "Ski Goggles", url: "https://amzn.to/4aH7G3A"),
        ],

        // Golf
        "golf": [
            "clubs": MVPProduct(name: "Callaway Golf Club Set", url: "https://amzn.to/4aH7IbI"),
            "balls": MVPProduct(name: "Titleist Pro V1", url: "https://amzn.to/4cFrI0U"),
            "bag": MVPProduct(name: "TaylorMade Golf Bag", url: "https://amzn.to/4cDCfts"),
            "clothing": MVPProduct(name: "Golf Polo Shirt", url: "https://amzn.to/40moOXz"),
            "gps": MVPProduct(name: "Bushnell Rangefinder", url: "https://amzn.to/46kQgsb"),
        ],

        // Running
        "running": [
            "shoes": MVPProduct(name: "Nike Pegasus", url: "https://amzn.to/4s1ODba"),
            "clothing": MVPProduct(name: "Running Shorts", url: "https://amzn.to/4cM31Qm"),
            "watch": MVPProduct(name: "Garmin Forerunner", url: "https://amzn.to/474KYkP"),
            "accessories": MVPProduct(name: "Running Armband", url: "https://amzn.to/4s85UQi"),
        ],

        // Sports Nutrition
        "sports-nutrition": [
            "protein": MVPProduct(name: "MyProtein Impact Whey", url: "https://amzn.to/4tMSQkT"),
            "preworkout": MVPProduct(name: "C4 Pre-Workout", url: "https://amzn.to/4u3alO2"),
            "bars": MVPProduct(name: "Grenade Protein Bars", url: "https://amzn.to/4aDtxKF"),
            "vitamins": MVPProduct(name: "Multivitamin Tablets", url: "https://amzn.to/4u3asJs"),
        ],

        // =============================================
        // HEALTH & BEAUTY
        // =============================================

        // Premium Beauty
        "premium-beauty": [
            "skincare": MVPProduct(name: "Estée Lauder Serum", url: "https://amzn.to/4l799VT"),
            "makeup": MVPProduct(name: "Charlotte Tilbury Makeup", url: "https://amzn.to/4atetiv"),
            "fragrance": MVPProduct(name: "Dior Sauvage", url: "https://amzn.to/4kThoom"),
            "haircare": MVPProduct(name: "Kerastase Hair Set", url: "https://amzn.to/4cB6hOA"),
        ],

        // Beauty Bundles
        "beauty-bundles": [
            "skincare": MVPProduct(name: "Skincare Gift Set", url: "https://amzn.to/4aRW4em"),
            "makeup": MVPProduct(name: "Makeup Gift Set", url: "https://amzn.to/4c7U7MX"),
            "fragrance": MVPProduct(name: "Fragrance Gift Set", url: "https://amzn.to/40lNPlB"),
            "grooming": MVPProduct(name: "Men's Grooming Kit", url: "https://amzn.to/3ZLm3ir"),
        ],

        // Hair Care
        "hair-care": [
            "shampoo": MVPProduct(name: "Moroccanoil Set", url: "https://amzn.to/474LeQP"),
            "styling": MVPProduct(name: "American Crew Pomade", url: "https://amzn.to/4s8EWrH"),
            "treatment": MVPProduct(name: "Olaplex No.3", url: "https://amzn.to/4azufXK"),
            "tools": MVPProduct(name: "Dyson Airwrap", url: "https://amzn.to/46k2WQd"),
        ],

        // Skin Care (first question: "Main skin concern?")
        "skin-care": [
            "acne": MVPProduct(name: "CeraVe Acne Cleanser", url: "https://amzn.to/4rEiO8D"),
            "aging": MVPProduct(name: "L'Oréal Revitalift", url: "https://amzn.to/3ZKI4xN"),
            "hydration": MVPProduct(name: "Neutrogena Hydro Boost", url: "https://amzn.to/4aurQ1T"),
            "brightening": MVPProduct(name: "The Ordinary Vitamin C", url: "https://amzn.to/4s1Pj0c"),
            "sensitivity": MVPProduct(name: "Aveeno Calm + Restore", url: "https://amzn.to/4rxJdVE"),
        ],

        // Dermatological Skincare (first question: "Skin condition?")
        "dermatological-skincare": [
            "eczema": MVPProduct(name: "E45 Cream", url: "https://amzn.to/3OsbD4U"),
            "psoriasis": MVPProduct(name: "Dermalex Psoriasis", url: "https://amzn.to/4asARZo"),
            "rosacea": MVPProduct(name: "La Roche-Posay Rosaliac", url: "https://amzn.to/4c18yCu"),
            "sensitive": MVPProduct(name: "Avene Tolerance", url: "https://amzn.to/4aEEZEl"),
        ],

        // Make-up
        "makeup": [
            "face": MVPProduct(name: "Maybelline Fit Me Foundation", url: "https://amzn.to/4aEEZEl"),
            "eyes": MVPProduct(name: "Maybelline Mascara", url: "https://amzn.to/46U2ckT"),
            "lips": MVPProduct(name: "MAC Lipstick", url: "https://amzn.to/4qNk9J2"),
            "brushes": MVPProduct(name: "Real Techniques Brush Set", url: "https://amzn.to/4tOU7I5"),
        ],

        // Nail Care
        "nail-care": [
            "polish": MVPProduct(name: "Essie Nail Polish", url: "https://amzn.to/4tOwTBW"),
            "gel": MVPProduct(name: "Gel Nail Starter Kit", url: "https://amzn.to/4kQuGSz"),
            "tools": MVPProduct(name: "Nail Care Tool Set", url: "https://amzn.to/46k5jCB"),
            "treatment": MVPProduct(name: "OPI Nail Strengthener", url: "https://amzn.to/4rvhk0w"),
        ],

        // Bath & Body
        "bath-body": [
            "bodywash": MVPProduct(name: "Dove Body Wash", url: "https://amzn.to/4kKWh7q"),
            "lotion": MVPProduct(name: "Nivea Body Lotion", url: "https://amzn.to/3ZKxve6"),
            "scrub": MVPProduct(name: "Frank Body Scrub", url: "https://amzn.to/3OVfc3q"),
            "bath": MVPProduct(name: "Bath Bomb Set", url: "https://amzn.to/3Myd5C5"),
        ],

        // Fragrance (first question: "Who is it for?")
        "fragrance": [
            "women": MVPProduct(name: "Chanel Coco Mademoiselle", url: "https://amzn.to/4kXyBgf"),
            "men": MVPProduct(name: "Dior Sauvage", url: "https://amzn.to/46izlqa"),
            "unisex": MVPProduct(name: "Tom Ford Oud Wood", url: "https://amzn.to/4rtEx2W"),
        ],

        // Men's Grooming
        "mens-grooming": [
            "shaving": MVPProduct(name: "Gillette Fusion Razor", url: "https://amzn.to/4c7e2f4"),
            "beard": MVPProduct(name: "Beard Grooming Kit", url: "https://amzn.to/4tJcu1b"),
            "skincare": MVPProduct(name: "Men's Face Moisturiser", url: "https://amzn.to/3MKbitz"),
            "haircare": MVPProduct(name: "Men's Shampoo", url: "https://amzn.to/3OBzNty"),
        ],

        // Health & Personal Care
        "health-personal-care": [
            "dental": MVPProduct(name: "Oral-B Electric Toothbrush", url: "https://amzn.to/40lQUSH"),
            "vitamins": MVPProduct(name: "Vitamin D Tablets", url: "https://amzn.to/3OBzUW0"),
            "firstaid": MVPProduct(name: "First Aid Kit", url: "https://amzn.to/4tMWwDd"),
            "massage": MVPProduct(name: "Massage Gun", url: "https://amzn.to/3ZOrxcc"),
        ],

        // =============================================
        // FILMS, TV, MUSIC & GAMES
        // =============================================

        // DVD & Blu-ray
        "dvd-bluray": [
            "movies": MVPProduct(name: "Popular Movie Blu-ray", url: "https://amzn.to/4tLiNkC"),
            "tvseries": MVPProduct(name: "TV Series Box Set", url: "https://amzn.to/4aDwTgJ"),
            "4k": MVPProduct(name: "4K Movie Disc", url: "https://amzn.to/4kMZnYL"),
            "boxset": MVPProduct(name: "Movie Box Set", url: "https://amzn.to/3Mqimvv"),
        ],

        // CDs & Vinyl (first question: "What format?")
        "cds-vinyl": [
            "vinyl": MVPProduct(name: "Classic Vinyl Album", url: "https://amzn.to/4s3cAPs"),
            "cd": MVPProduct(name: "Popular Music CD", url: "https://amzn.to/4qPcGt0"),
        ],

        // Musical Instruments & DJ
        "musical-instruments": [
            "guitar": MVPProduct(name: "Acoustic Guitar", url: "https://amzn.to/4rBcLlo"),
            "keyboard": MVPProduct(name: "Digital Keyboard", url: "https://amzn.to/46lQAXI"),
            "drums": MVPProduct(name: "Electronic Drum Kit", url: "https://amzn.to/3MBnY6a"),
            "dj": MVPProduct(name: "DJ Controller", url: "https://amzn.to/4s3cU0C"),
            "other": MVPProduct(name: "Ukulele", url: "https://amzn.to/3OBAy5S"),
        ],

        // PC & Video Games (Entertainment)
        "entertainment-games": [
            "ps5": MVPProduct(name: "PS5 Game", url: "https://amzn.to/4aOKikP"),
            "xbox": MVPProduct(name: "Xbox Game", url: "https://amzn.to/4ru9VhJ"),
            "switch": MVPProduct(name: "Switch Game", url: "https://amzn.to/4qQDvNt"),
            "pc": MVPProduct(name: "PC Game", url: "https://amzn.to/4c8kjqU"),
        ],

        // =============================================
        // BOOKS
        // =============================================

        // All Books (first question: "What format?")
        "books-general": [
            "paperback": MVPProduct(name: "Atomic Habits (Paperback)", url: "https://amzn.to/3ZKyLxQ"),
            "hardback": MVPProduct(name: "Sapiens (Hardback)", url: "https://amzn.to/3OrbCy2"),
            "ebook": MVPProduct(name: "Atomic Habits (Kindle)", url: "https://amzn.to/4qKhy2r"),
            "audiobook": MVPProduct(name: "Atomic Habits (Audible)", url: "https://amzn.to/40oCUrm"),
        ],
    ]
}
