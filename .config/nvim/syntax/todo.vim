syntax match Special /[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} (\a\{3\}):/ " date headers

syntax match Identifier /(\a\+ly) / " (daily), (monthly), etc
syntax match Identifier /(every \d\+ \a\+) / " (every 2 months), etc
syntax match Identifier /(\w\+ of every \w\+) / " (1st of every month), etc

syntax match Type /^\s*\*\+\s/ " task completion markers
syntax match Type /^\s*-\s/ " task completion markers

syntax match Identifier /^\s\+[a-z]\./ " option list a., b., etc
