# Kido Chef — App Store listing

Copy-paste these fields into App Store Connect. Screenshots live in `screenshots/`.
Support and Privacy pages live in `/docs` for GitHub Pages.

## Identity

| Field | Value |
| --- | --- |
| App name (30) | `Kido Chef` |
| Subtitle (30) | `Kids Cooking & Food Fun` |
| Bundle ID | `com.sreedhar.CrazyFoodFactory` |
| SKU | `kido-chef-ios` |
| Primary language | English (US) |
| Display name on home screen | Kido Chef |
| Version | 1.0 |
| Build | 1 |
| Copyright | 2026 Sai Laksha Technologies |
| Company | Sai Laksha Technologies |
| Studio | sreeo |

Name is 9 characters. Subtitle is 23.

## Category

| Field | Value |
| --- | --- |
| Primary | Games |
| Games subcategory | Kids |
| Secondary | Education |
| Age rating | 4+ |
| Made for Kids | No — keep as a 4+ game unless you later add a parental gate on every outbound link |

Apple may still ask Kids-category questions because the listing talks to families. Answer: no user-generated content, no social, no ads, no third-party analytics, no in-app purchases.

## Pricing

Free. No In-App Purchases. No ads.

## Promotional text (170)

Little chefs tap toppings onto pizza, dosa, nachos and more. Ingredient School teaches what foods are and how we cook them. Offline, no login — just kitchen fun.

(161 characters)

## Description

Kido Chef is a colorful cooking game for little hands.

Kids tap real-looking ingredients onto pizza, dosa, nachos, ramen, and lots of other dishes. No recipes to read. No timers to fail. Just cook, giggle, and try again.

COOK THE WORLD
• Classics: pizza, burgers, ice cream, donuts, and more
• South Indian: dosa, idli, sambar, vada
• Indian: biryani, paneer tikka, chole, mango lassi
• Mexican: nachos, burrito, guacamole, elote
• Around the world: ramen, sushi rolls, falafel, hummus

INGREDIENT SCHOOL
Open a separate Learn Ingredients path to hear what a tomato, mango, or paneer is — and how chefs use it. Grown-ups can leave kids here when they want a calmer, teaching moment.

MADE FOR REAL LIFE
• Fully offline — works in the car, on a plane, or at grandma’s
• No login, no chat, no ads
• Big tap targets and a clay, cartoon kitchen
• Stars, rewards, and a shareable chef card when you want to celebrate
• Music, sounds, and chef voice can be turned off in Settings

Kido Chef is from sreeo, the studio of Sai Laksha Technologies.

## Keywords (100)

kids cooking,food game,pizza,dosa,chef,toddler,preschool,learn foods,offline,kids games

Character count: 87. Do not repeat the app name. No spaces after commas.

## What’s New (1.0)

Welcome to Kido Chef! Cook pizza, dosa, nachos, ramen, and more. Learn ingredients in Ingredient School. Fully offline, no login.

## URLs

Enable GitHub Pages on this repo: Settings → Pages → Deploy from a branch → `/docs` on `main`.

After Pages is live:

| Field | Value |
| --- | --- |
| Support URL | https://sreedharlakshman2.github.io/CrazyFoodFactory/ |
| Privacy Policy | https://sreedharlakshman2.github.io/CrazyFoodFactory/privacy.html |
| Marketing URL | leave blank, or the Support URL |

These match `Brand.supportURL` and `Brand.privacyURL` in the app. The iOS Settings screens use in-app Privacy and Support text — they do not show an email.

## App Review notes

Kido Chef is an offline kids cooking game. There is no account and no login.

To try the kitchen:
1. Launch the app and wait through the sreeo splash.
2. Tap PLAY.
3. Choose Pizza (or Dosa / Nachos).
4. Tap toppings on the tray, then follow the speech bubble.

To try Ingredient School: from Home, tap Learn Ingredients.

Demo account: none.
Contact for review: sreedharlakshmanan4@gmail.com

## Age rating answers

| Question | Answer |
| --- | --- |
| Cartoon or fantasy violence | None |
| Realistic violence | None |
| Profanity or crude humor | None |
| Alcohol, tobacco, drugs | None |
| Medical / treatment info | None |
| Gambling | None |
| Horror / fear themes | None |
| Mature / suggestive | None |
| Unrestricted web access | No |
| User-generated content | No |
| Messaging / chat | No |
| Advertising | No |

Expected rating: 4+.

## Privacy nutrition labels

Data Not Collected.

Optional photo-library add permission appears only if someone taps Share Reward. That image is saved locally or handed to the system share sheet. It is not uploaded to us.

## Screenshots

Upload **portrait** images.

1. iPhone 6.9" (`AppStore/screenshots/iphone-69/`) — required
2. iPad 13" (`AppStore/screenshots/ipad-13/`) — required because the binary includes iPad

Upload order (this is the App Store gallery order):

1. `01-home.png` — Let’s cook!
2. `02-foods.png` — So many kitchens!
3. `03-pizza.png` — Build a pizza
4. `04-dosa.png` — Dosa & chutney
5. `05-school.png` — Learn foods
6. `06-result.png` — You did it
7. `07-howto.png` — Easy to play

Each iPhone file is 1320 × 2868. Each iPad file is 2064 × 2752.
They are framed marketing shots: gradient header + title + the **real app UI** captured from the simulator.

Regenerate:

```bash
chmod +x AppStore/capture_screens.sh
AppStore/capture_screens.sh
python3 AppStore/compose_screenshots.py
```

Raw simulator captures land in `AppStore/raw/`. Composed store images land in `AppStore/screenshots/`.

## App icon

`CrazyFoodFactory/Assets.xcassets/AppIcon.appiconset/AppIcon.png` (1024 × 1024).
Do not add gloss or rounded corners — App Store applies the mask.

## Localization

English only for 1.0 is enough. The UI is English with speech in en-US.

## Pre-submit checklist

- [ ] GitHub Pages `/docs` is live and the Privacy URL loads
- [ ] Screenshots uploaded for iPhone 6.9" and iPad 13"
- [ ] Export a Release archive from Xcode (Product → Archive) with team `7DS2M392U2`
- [ ] Encryption question: this app uses only exempt / standard HTTPS for optional GitHub Pages links; ITSAppUsesNonExemptEncryption is already NO
- [ ] Content rights: all kitchen art is original to this project
- [ ] Contact email for App Review is sreedharlakshmanan4@gmail.com
