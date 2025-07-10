# maxregnerOS GitHub Workflows

This directory contains GitHub Actions workflows for automated building, testing, and releasing of maxregnerOS with the Ultra-Fast Architecture.

## 🚀 Available Workflows

### 1. Build maxregnerOS Ultra-Fast (`build-maxregneros.yml`)

**Triggers:**
- Push to `main`, `develop`, or `codegen-bot/**` branches
- Pull requests to `main` or `develop`
- Manual workflow dispatch

**Features:**
- 🏗️ **Multi-component build** (kernel, MROS DDE, vibrant skin)
- 💿 **Automated ISO creation** with bootable configuration
- 🌐 **Upload to bashupload.com** for easy distribution
- 📊 **Performance level selection** (conservative, balanced, aggressive, extreme)
- 🎉 **Automatic GitHub releases** for main branch pushes
- 📤 **Artifact management** with 90-day retention

**Build Matrix:**
- **Kernel**: Enhanced with Ultra-Fast Architecture
- **MROS DDE**: Desktop manager and panel components
- **Vibrant Skin**: Custom maxregnerOS-vibrant theme

**Outputs:**
- Bootable ISO files
- Component artifacts
- System information files
- Download links from bashupload.com

### 2. Test maxregnerOS Ultra-Fast (`test-maxregneros.yml`)

**Triggers:**
- Push to any branch
- Pull requests
- Daily scheduled runs (2 AM UTC)

**Test Categories:**
- 🔍 **Code Quality Check**: Assembly syntax validation, architecture component verification
- 🔨 **Build Test**: Multi-performance level build testing
- 📊 **Performance Analysis**: Ultra-Fast Architecture feature validation
- 📚 **Documentation Check**: Documentation completeness and quality
- 🔒 **Security Check**: Security pattern analysis and vulnerability scanning
- 🔗 **Integration Test**: Component integration verification

**Performance Validation:**
- Memory management optimizations
- I/O subsystem enhancements
- File system caching features
- Scheduler improvements
- Hardware acceleration support

### 3. Release maxregnerOS Ultra-Fast (`release-maxregneros.yml`)

**Triggers:**
- Git tags matching `v*` pattern
- Manual workflow dispatch with version input

**Release Variants:**
- **Standard** (`balanced`): Balanced performance and stability
- **Performance** (`aggressive`): High performance with aggressive optimizations
- **Extreme** (`extreme`): Maximum performance with extreme optimizations

**Features:**
- 🏷️ **Automatic tag creation** (optional)
- 📦 **Multi-variant builds** with different optimization levels
- 🌐 **Upload to bashupload.com** for all variants
- 🎉 **GitHub release creation** with comprehensive release notes
- 📤 **Asset management** with download links

## 🛠️ Workflow Configuration

### Environment Variables

```yaml
MAXREGNEROS_VERSION: "1.0.0"
BUILD_TYPE: "ultra-fast"
PERFORMANCE_LEVEL: "balanced"  # conservative, balanced, aggressive, extreme
```

### Performance Levels

| Level | Description | Use Case |
|-------|-------------|----------|
| `conservative` | Safe optimizations, maximum stability | Production environments |
| `balanced` | Good performance with stability (default) | General use |
| `aggressive` | High performance with some stability trade-offs | Performance-critical applications |
| `extreme` | Maximum performance, minimal safety checks | Benchmarking and testing |

### Build Tools

The workflows automatically install and configure:
- **FASM** (Flat Assembler) for assembly compilation
- **NASM** for additional assembly support
- **genisoimage/xorriso** for ISO creation
- **isolinux/syslinux** for bootloader configuration
- **curl/wget** for file downloads and uploads

## 📊 Workflow Outputs

### Build Artifacts

1. **Component Artifacts**:
   - `maxregneros-kernel-{build-id}`: Enhanced kernel with Ultra-Fast Architecture
   - `maxregneros-mros-dde-{build-id}`: MROS Desktop Environment components
   - `maxregneros-vibrant-skin-{build-id}`: Custom vibrant skin theme

2. **ISO Artifacts**:
   - `maxregnerOS-iso-{build-id}`: Complete bootable ISO file
   - `download-info-{build-id}`: Download information and links

3. **Release Artifacts**:
   - Multiple variant ISO files (standard, performance, extreme)
   - Release notes and system information
   - Download links for bashupload.com

### Test Reports

- Code quality assessment
- Performance feature validation
- Documentation completeness check
- Security scan results
- Integration test results

## 🚀 Usage Examples

### Manual Build Trigger

```bash
# Trigger build workflow manually
gh workflow run build-maxregneros.yml \
  -f performance_level=aggressive \
  -f upload_to_bashupload=true
```

### Manual Release Creation

```bash
# Create a new release
gh workflow run release-maxregneros.yml \
  -f version=1.0.1 \
  -f performance_level=extreme \
  -f create_tag=true
```

### Check Workflow Status

```bash
# List recent workflow runs
gh run list --workflow=build-maxregneros.yml

# View specific run details
gh run view <run-id>
```

## 🔧 Customization

### Adding New Performance Levels

1. Update the `performance_level` choice options in workflow files
2. Add corresponding build logic in the build scripts
3. Update documentation and release notes

### Modifying Build Components

1. Update the component matrix in `build-maxregneros.yml`
2. Add new build steps for additional components
3. Update artifact collection and packaging

### Custom Upload Destinations

1. Modify the upload steps in workflows
2. Add new environment variables for credentials
3. Update download link generation

## 📋 Workflow Dependencies

### Required Secrets

- `GITHUB_TOKEN`: Automatically provided by GitHub Actions
- Additional secrets may be needed for custom upload destinations

### Required Permissions

- **Contents**: Read/write for repository access
- **Actions**: Write for workflow management
- **Releases**: Write for creating GitHub releases

## 🐛 Troubleshooting

### Common Issues

1. **FASM Installation Failure**:
   - Check FASM download URL and version
   - Verify installation permissions

2. **ISO Creation Failure**:
   - Fallback to archive creation (tar.gz)
   - Check isolinux/syslinux configuration

3. **Upload Failures**:
   - Verify bashupload.com availability
   - Check file size limits

4. **Build Timeouts**:
   - Increase timeout values in workflow configuration
   - Optimize build scripts for faster execution

### Debug Mode

Enable debug logging by setting:
```yaml
env:
  ACTIONS_STEP_DEBUG: true
  ACTIONS_RUNNER_DEBUG: true
```

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [maxregnerOS Ultra-Fast Architecture](../kernel/trunk/maxregneros-arch/README.md)
- [MROS Desktop Environment](../programs/mros-dde/README.md)
- [Build Scripts Documentation](../scripts/README.md)

---

**maxregnerOS GitHub Workflows** - *Automated building for ultra-fast computing!* 🚀

