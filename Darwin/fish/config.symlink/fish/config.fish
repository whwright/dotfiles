alias prettyjson "python -m json.tool"

ulimit -n 65536
ulimit -u 2048

set -x EDITOR vim
set -x PATH /usr/local/bin $PATH

# BUILD VARIABLES
# TODO: cleanup
set -x JAVA_HOME_7 /Library/Java/JavaVirtualMachines/jdk1.7.0_75.jdk/Contents/Home
set -x JAVA_HOME_6 /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
set -x JAVA_HOME $JAVA_HOME_7
set -x ECLIPSE_HOME ~/Development/eclipse-clean
set -x ANDROID_HOME /Users/wrighthw/Library/Android/sdk
set -x MAVEN_OPTS "-Xmx512m -XX:MaxPermSize=512m"

# GIT PROMPT CONFIG
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_char_dirtystate "+"
set -g __fish_git_prompt_char_untrackedfiles "."
set -g __fish_git_prompt_color_branch magenta
set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
set -g __fish_git_prompt_color_cleanstate green