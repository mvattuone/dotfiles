function bobthefish_colors -S -d 'Define a custom bobthefish color scheme'

  # Optionally include a base color scheme
  __bobthefish_colors default

  # Custom colors - names from http://chir.ag/projects/name-that-color
  set -l havelock_blue 5697d8
  set -l forest_green 228b22
  set -l yellow_orange ffb347

  # Then override everything you want!
  # Note that these must be defined with `set -x`
  set -x color_initial_segment_exit     white red --bold
  set -x color_initial_segment_su       white green --bold
  set -x color_initial_segment_jobs     white blue --bold

  set -x color_path                     $havelock_blue white
  set -x color_path_basename            $havelock_blue white --bold
  set -x color_path_nowrite             magenta black
  set -x color_path_nowrite_basename    magenta black --bold

  set -x color_repo                     $forest_green white
  set -x color_repo_work_tree           $forest_green black --bold
  set -x color_repo_dirty               red black
  set -x color_repo_staged              $forest_green black

  set -x color_vi_mode_default          yellow black --bold
  set -x color_vi_mode_insert           $yellow_orange black --bold
  set -x color_vi_mode_visual           purple black --bold

  set -x color_vagrant                  brcyan black
  set -x color_k8s                      magenta white --bold
  set -x color_username                 white black --bold
  set -x color_hostname                 white black
  set -x color_rvm                      brmagenta black --bold
  set -x color_virtualfish              brblue black --bold
  set -x color_virtualgo                brblue black --bold
  set -x color_desk                     brblue black --bold
end
