linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
findFile = require "#{linterPath}/lib/util"

class LinterJsxhint extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.js', 'source.jsx', 'source.js.jquery', 'text.html.basic']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: 'cli.js --verbose --extract=auto'

  linterName: 'jsxhint'

  # A regex pattern used to extract information from the executable's output.
  regex:
    '((?<fail>ERROR: .+)|' +
    '.+?: line (?<line>[0-9]+), col (?<col>[0-9]+), ' +
    '(?<message>.+) ' +
    # capture error, warning and code
    '\\(((?<error>E)|(?<warning>W))(?<code>[0-9]+)\\)'+
    # '\\((?<warning>.).+\\)'
    ')'

  isNodeExecutable: yes

  constructor: (editor) ->
    super(editor)

    config = findFile @cwd, ['.jshintrc']
    if config
      @cmd += " -c #{config}"

    atom.config.observe 'linter-jsxhint.jsxhintExecutablePath', @formatShellCmd

  formatShellCmd: =>
    jsxhintExecutablePath = atom.config.get 'linter-jsxhint.jsxhintExecutablePath'
    @executablePath = "#{jsxhintExecutablePath}"

  destroy: ->
    atom.config.unobserve 'linter-jsxhint.jsxhintExecutablePath'

module.exports = LinterJsxhint
