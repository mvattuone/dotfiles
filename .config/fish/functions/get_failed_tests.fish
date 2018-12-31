function get_failed_tests
  pbpaste | grep testMethod | sed 's/# self = <//' | sed 's/>//' | sed 's/\./\//g' | sed 's/_test\//_test.py::/' | sed 's/ testMethod\=/::/' | tr '\n' ' ' | pbcopy
end
