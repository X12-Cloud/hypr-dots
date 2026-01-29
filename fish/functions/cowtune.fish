    function cowtune --description "Get a fortune told by a custom cow"
      # Parse only the -f flag for cowsay. All other args go to fortune.
      argparse "f/cowfile=" -- $argv

      set -l cowsay_opts

      # If -f was provided, add it to cowsay options
      if set -q _flag_cowfile
        set cowsay_opts -f $_flag_cowfile
      end

      # The output of fortune is then piped to cowsay with its options
      fortune | cowsay $cowsay_opts
    end
    
