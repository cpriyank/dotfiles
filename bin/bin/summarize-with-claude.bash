WORKFLOW_DIR="$HOME/Library/Services/Summarize with Claude.workflow/Contents"
mkdir -p "$WORKFLOW_DIR"
# Create Info.plist
cat > "$WORKFLOW_DIR/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSServices</key>
    <array>
        <dict>
            <key>NSMenuItem</key>
            <dict>
                <key>default</key>
                <string>Summarize with Claude</string>
            </dict>
            <key>NSMessage</key>
            <string>runWorkflowAsService</string>
            <key>NSRequiredContext</key>
            <dict/>
            <key>NSSendTypes</key>
            <array>
                <string>public.plain-text</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
PLIST
# Create document.wflow
cat > "$WORKFLOW_DIR/document.wflow" << 'WFLOW'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>AMApplicationBuild</key>
    <string>523</string>
    <key>AMApplicationVersion</key>
    <string>2.10</string>
    <key>AMDocumentVersion</key>
    <string>2</string>
    <key>actions</key>
    <array>
        <dict>
            <key>action</key>
            <dict>
                <key>AMAccepts</key>
                <dict>
                    <key>Container</key>
                    <string>List</string>
                    <key>Optional</key>
                    <true/>
                    <key>Types</key>
                    <array>
                        <string>com.apple.cocoa.string</string>
                    </array>
                </dict>
                <key>AMActionVersion</key>
                <string>2.0.3</string>
                <key>AMApplication</key>
                <array>
                    <string>Automator</string>
                </array>
                <key>AMCategory</key>
                <string>AMCategoryUtilities</string>
                <key>AMIconName</key>
                <string>Run Shell Script</string>
                <key>AMName</key>
                <string>Run Shell Script</string>
                <key>AMParameters</key>
                <dict>
                    <key>COMMAND_STRING</key>
                    <string>~/.local/bin/context-menu-summarize.sh</string>
                    <key>CheckedForUserDefaultShell</key>
                    <true/>
                    <key>inputMethod</key>
                    <integer>0</integer>
                    <key>shell</key>
                    <string>/bin/bash</string>
                    <key>source</key>
                    <string></string>
                </dict>
                <key>AMProvides</key>
                <dict>
                    <key>Container</key>
                    <string>List</string>
                    <key>Types</key>
                    <array>
                        <string>com.apple.cocoa.string</string>
                    </array>
                </dict>
                <key>AMRequiredResources</key>
                <array/>
                <key>ActionBundlePath</key>
                <string>/System/Library/Automator/Run Shell Script.action</string>
                <key>ActionName</key>
                <string>Run Shell Script</string>
                <key>ActionParameters</key>
                <dict>
                    <key>COMMAND_STRING</key>
                    <string>~/.local/bin/context-menu-summarize.sh</string>
                    <key>CheckedForUserDefaultShell</key>
                    <true/>
                    <key>inputMethod</key>
                    <integer>0</integer>
                    <key>shell</key>
                    <string>/bin/bash</string>
                    <key>source</key>
                    <string></string>
                </dict>
                <key>BundleIdentifier</key>
                <string>com.apple.RunShellScript</string>
                <key>CFBundleVersion</key>
                <string>2.0.3</string>
                <key>CanShowSelectedItemsWhenRun</key>
                <false/>
                <key>CanShowWhenRun</key>
                <true/>
                <key>Category</key>
                <array>
                    <string>AMCategoryUtilities</string>
                </array>
                <key>Class Name</key>
                <string>RunShellScriptAction</string>
                <key>InputUUID</key>
                <string>D4E5F6A7-B8C9-0123-DEF0-123456789ABC</string>
                <key>Keywords</key>
                <array>
                    <string>Shell</string>
                    <string>Script</string>
                    <string>Command</string>
                    <string>Run</string>
                    <string>Unix</string>
                </array>
                <key>OutputUUID</key>
                <string>E5F6A7B8-C9D0-1234-EF01-23456789ABCD</string>
                <key>UUID</key>
                <string>F6A7B8C9-D0E1-2345-F012-3456789ABCDE</string>
                <key>UnlocalizedApplications</key>
                <array>
                    <string>Automator</string>
                </array>
            </dict>
            <key>class</key>
            <string>AMBundleAction</string>
            <key>identifier</key>
            <string>com.apple.Automator.RunShellScript</string>
            <key>parameters</key>
            <dict>
                <key>COMMAND_STRING</key>
                <string>~/.local/bin/context-menu-summarize.sh</string>
                <key>CheckedForUserDefaultShell</key>
                <true/>
                <key>inputMethod</key>
                <integer>0</integer>
                <key>shell</key>
                <string>/bin/bash</string>
                <key>source</key>
                <string></string>
            </dict>
        </dict>
    </array>
    <key>connectors</key>
    <dict/>
    <key>workflowMetaData</key>
    <dict>
        <key>workflowTypeIdentifier</key>
        <string>com.apple.Automator.servicesMenu</string>
    </dict>
</dict>
</plist>
WFLOW
echo "Created: Summarize with Claude.workflow"
# ============================================
# Refresh Services
# ============================================
/System/Library/CoreServices/pbs -update
echo ""
echo "=========================================="
echo "Workflows created successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Store your API key in Keychain:"
echo "   security add-generic-password -a \"\$USER\" -s \"anthropic-api-key\" -w \"YOUR_API_KEY\""
echo ""
echo "2. Make sure shell scripts are executable:"
echo "   chmod +x ~/.local/bin/context-menu-tts.sh"
echo "   chmod +x ~/.local/bin/context-menu-summarize.sh"
echo ""
echo "3. Select text anywhere, right-click > Services to see the options"
echo ""
echo "4. Optional: Assign keyboard shortcuts in"
echo "   System Settings > Keyboard > Keyboard Shortcuts > Services"
