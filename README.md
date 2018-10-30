# Bumblebee
iOS Componentization 

```objc
    [Bumblebee createBumblebeeEntrance:@"ComBEntrance"];
    BeeRequest *req = [BeeRequestFactory BeeOpenTargetRequest:@"ComBEntrance"];
    req.parameter = @{@"Text":_textField.text, @"VC":self.preVc};
    req.actionName = @"getComAdelegateData";
    [Bumblebee openTargetWithPramas:req resultBlock:^(BeeResponse *info) {
        
    }];
```
