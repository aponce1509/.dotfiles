# {{title}}
#task-page

![[_ Current bi-Week Note#^week-objetives]]

- 

### Active Projects

```dataview
TABLE status 
FROM "" AND !"99 - Meta"
WHERE contains(file_class, "project") and status != "📦"
sort status
```

## Task Inbox
```tasks
not done
group by due
due after {{daily_tasks_minus_3}}
due before {{daily_tasks_plus_2}}
sort by priority
sort by due
```

## Daily Log
