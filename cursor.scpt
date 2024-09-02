on run

  set theQuery to "{query}"
  set finderSelection to ""
  set theTarget to ""
  set defaultTarget to (path to home folder as alias)
  -- comment line above and uncomment line below to open desktop instead of user home when there's no selection or open folder in the Finder:
  -- set defaultTarget to (path to desktop folder as alias)

  if theQuery is "" then
      tell application "Finder"
          set finderSelection to (get selection)
          if length of finderSelection is greater than 0 then
              set theTarget to finderSelection
          else
              try
                  set theTarget to (folder of the front window as alias)
              on error
                  set theTarget to defaultTarget
              end try
          end if

          tell application "Cursor"
              open theTarget as alias
          end tell

      end tell
  else
      try
          set targets to {}
          set oldDelimiters to text item delimiters
          set text item delimiters to tab
          set qArray to every text item of theQuery
          set text item delimiters to oldDelimiters
          repeat with atarget in qArray
              log "Processing target: " & atarget  -- 添加调试信息
              if atarget starts with "~" then
                  set userHome to POSIX path of (path to home folder)
                  log "User home path: " & userHome  -- 添加调试信息
                  if userHome ends with "/" then
                      set userHome to characters 1 thru -2 of userHome as string
                  end if

                  try
                      set atarget to userHome & characters 2 thru -1 of atarget as string
                      log "Resolved target: " & atarget  -- 添加调试信息
                  on error
                      log "Error resolving target: " & atarget  -- 添加调试信息
                      set atarget to userHome
                  end try
              end if

              log "Final atarget before conversion: " & atarget  -- 添加调试信息
              try
                  set targetAlias to ((POSIX file atarget) as alias)
                  log "Target alias: " & targetAlias  -- 添加调试信息
                  set targets to targets & targetAlias
              on error
                  log "Error converting to alias: " & atarget  -- 添加调试信息
              end try
          end repeat

          set theTarget to targets

          tell application "Cursor"
              open theTarget
          end tell

      on error
          return (atarget as string) & " is not a valid file or folder path."
      end try
  end if

  return theQuery
end run