# Shiptivity Kanban Board: analysis and three ideas

All numbers come from `shiptivity.db` using the queries in `answer.sql`.
The Kanban Board was released on 2018-06-02. Data runs from 2018-02-03 to 2019-02-01.

## What the data says

**Daily active users (graph 1)**

| | Before (2018-02-03 to 2018-06-01) | After (2018-06-02 to 2019-02-01) |
|---|---|---|
| Days with at least one login | 110 | 245 |
| Average daily active users | **3.63** | **11.79** (3.2x) |
| Distinct users who logged in | 38 | 99 |

- Counting the 9 days before release with no logins as zero, the "before" average is 3.35, so the jump is slightly bigger (3.5x). The conclusion does not change.
- Usage was already climbing in May (April 3.0, May 5.48) before it jumped to 11.93 in June, so not all of the lift is the release alone.
- After the jump, the monthly average peaked at 12.9 (July) and drifted down to 10.2 (January), about 21% lower.
- Engagement is uneven: since release the median user logged in 22 times in about 8 months. 36 of 99 users logged in 15 times or fewer, while 35 users logged in 40 times or more.

**Status changes by card (graph 2)**

- 286 real status changes across 200 cards (card creation rows are not counted).
- 100 cards moved exactly twice (backlog, then in progress, then complete), 53 moved once, and **38 never moved at all**. Only 9 cards moved three or more times.
- Forward moves dominate: 167 backlog to in-progress, 103 in-progress to complete. Only 16 moves (5.6%) went backwards, so people trust the flow.
- Starting work is the slow step: the median card waits about 50 days in backlog before it is started, then about 18 days to finish.
- 58 cards are sitting in "in progress", on average 54 days since they last moved. The 44 cards still in backlog have been untouched for about 102 days on average.
- New cards keep arriving at 19 to 35 per month, so the backlog keeps growing.

## Idea 1: Stale-card reminders

**Hypothesis:** Users forget to come back because nothing on a quiet day tells them there is something to do. A nudge that names the specific cards that have gone quiet will bring back the 36 occasional users, on days they would otherwise skip.

**Expected impact:** If those 36 occasional users logged in on just one extra day per month, that is about 36 x 8 months = 288 extra user-days over 245 days, roughly **+1.2 daily active users (about +10%)**. This is a back-of-envelope estimate, to be validated with an A/B test where half of the users get the reminders.

**What the feature is:** A weekly email or push notification that names the cards that have gone quiet, with a button that opens the board on those cards. Users can snooze a card or turn the reminder off. The example below uses real idle cards from the data.

```
+----------------------------------------------------+
| Shiptivity: 3 cards need attention                 |
|  - Schmitt-Collier         In progress, 195 days   |
|  - Schaefer LLC            In progress, 180 days   |
|  - Mraz, Davis and Schultz Backlog, 244 days       |
|  [ Open my board ]              [ Snooze 1 week ]  |
+----------------------------------------------------+
```

## Idea 2: "Start next" backlog triage

**Hypothesis:** Cards wait about 50 days in backlog because starting one means finding it among many and dragging it across the board, and nothing asks the user to decide. If picking the next card takes one click and the app asks for it, more cards will be started sooner and users will have a daily reason to open the board.

**Expected impact:** Cut the median backlog wait from about 50 days to about 30 days, and cut the share of cards that never move (19% today) in half. Measured through cards started per active user per week. Because each started card is a card the user will come back to finish, we expect daily active users to rise as well, which we would confirm in the test.

**What the feature is:** A "Start next" button at the top of the Backlog column that shows two or three suggested cards (oldest first, or starred). One click moves the card to In progress. Optionally, a "Today" shelf at the top of the board for the one to three cards the user commits to for the day.

```
Backlog                      In progress          Complete
+----------------------+     +--------------+     +--------------+
| [ Start next ]       |     |              |     |              |
|  Suggested:          | --> |  (card moves |     |              |
|   o Mraz, Davis and  |     |   here with  |     |              |
|     Schultz          |     |   one click) |     |              |
|   o Schneider, ...   |     |              |     |              |
+----------------------+     +--------------+     +--------------+
```

## Idea 3: Weekly progress recap and streak

**Hypothesis:** The daily active user count has slowly slipped about 21% since July even though the board keeps getting new cards, and 98 of 200 cards are already complete without the product ever showing users that progress. Showing users what they finished, and rewarding consecutive active days, gives them a reason to return and slows the decline.

**Expected impact:** Hold the monthly average at the July to November level of about 12 to 13 instead of letting it fall to about 10. Against January that is **about +2 daily active users (about +18%)**. Measured as monthly average daily active users and 30-day return rate, again via an A/B test.

**What the feature is:** A "This week" panel at the top of the board that shows cards completed this week, cards still in progress, and a streak counter ("4 days in a row"). On Monday, an optional recap email summarises last week.

```
+------------------------------------------------------+
|  This week:  6 cards completed   |  4 in progress    |
|  Streak: 4 days in a row         |  Last week: 3     |
+------------------------------------------------------+
|  Backlog        |  In progress     |  Complete       |
```

## Caveats

- This is a before/after comparison, not an experiment, so it shows what changed, not proof of cause. The May increase suggests the trend was already rising.
- The sample is small (100 users), so the monthly numbers move by a day or two with a handful of users. Impact figures above are estimates meant to be confirmed with tests.