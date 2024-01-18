package test

import (
	"testing"
    "strings"
    "fmt"
    "os"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/discovery"
)

// func TestAll(t *testing.T) {
// 	tft.AutoDiscoverAndTest(t) // would also include Jenkins "*@tmp" folder
// }

// AutoDiscoverAndTest discovers TF config from examples/fixtures and runs tests.
func TestAll(t *testing.T) {
    fmt.Println("Inside TestAll")
    currentWorkingDirectory, err := os.Getwd()
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Printf("Current Wroking Direcoty: %s", currentWorkingDirectory)
    configs := discovery.FindTestConfigs(t, "./")
    for testName, dir := range configs {
        if !(strings.HasSuffix(dir, "@tmp")) { // We exclude temporary folders created by JenkinsS
            fmt.Printf("testName: %s, dir: %s\n", testName, dir)
            t.Run(testName, func(t *testing.T) {
                nt := tft.NewTFBlueprintTest(t, tft.WithTFDir(dir))
                nt.Test()
            })
        }
    }
}
