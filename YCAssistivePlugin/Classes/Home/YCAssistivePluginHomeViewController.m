//
//  YCAssistivePluginHomeViewController.m
//  YCAssistivePlugin
//
//  Created by shenweihang on 2019/9/18.
//

#import "YCAssistivePluginHomeViewController.h"
#import "YCAssistiveFunctionModel.h"
#import "YCAssistiveFunctionCell.h"
#import "YCConsoleLoggerViewController.h"
#import "YCAssistiveCrashViewController.h"

#import "YCNetworkEnvironmentPlugin.h"
#import "YCURLPlugin.h"
#import "YCAppInfoPlugin.h"
#import "YCCrashPlugin.h"

#import "YCMemoryLeaksPlugin.h"

#import "YCColorSnapPlugin.h"
#import "YCLargeImagePlugin.h"

#import "UIViewController+AssistiveUtil.h"

@interface YCAssistivePluginHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<YCAssistiveFunctionViewModel *> *functions;

@end

@implementation YCAssistivePluginHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self as_setNavigationBarTitle:@"测试辅助工具"];
    [self as_setLeftBarItemTitle:@"关闭"];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self.tableView reloadData];
}

- (void)as_viewControllerDidTriggerLeftClick:(UIViewController *)viewController {
    
    [self pluginWindowDidClosed];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.functions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YCAssistiveFunctionCell heightForCell:self.functions[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCAssistiveFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YCAssistiveFunctionCell"];
    YCAssistiveFunctionViewModel *viewModel = self.functions[indexPath.row];
    [cell bindFunctionModel:viewModel];
    return cell;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100.0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[YCAssistiveFunctionCell class] forCellReuseIdentifier:@"YCAssistiveFunctionCell"];
    }
    return _tableView;
}

- (NSMutableArray<YCAssistiveFunctionViewModel *> *)functions {
    
    if (_functions == nil) {
        
        _functions = [[NSMutableArray alloc] init];
        [_functions addObject:[self commonlyUsedFunctions]];
        [_functions addObject:[self performanceDetectionFunctions]];
        [_functions addObject:[self visualSenseFunctions]];
    }
    return _functions;
}

- (YCAssistiveFunctionViewModel *)commonlyUsedFunctions {
    
    YCAssistiveFunctionModel *switcher = [YCAssistiveFunctionModel functionModelWithName:@"环境切换" imageName:@"icon_home_switcher" des:@"App内环境地址切换"];
    switcher.plugin = [[YCNetworkEnvironmentPlugin alloc] init];
    
    YCAssistiveFunctionModel *http = [YCAssistiveFunctionModel functionModelWithName:@"网络监测" imageName:@"icon_home_http" des:@"监测网络请求"];
    http.plugin = [[YCURLPlugin alloc] init];
    
    YCAssistiveFunctionModel *logger = [YCAssistiveFunctionModel functionModelWithName:@"用户日志" imageName:@"icon_home_logger" des:@"调试日志记录"];

    YCAssistiveFunctionModel *crash = [YCAssistiveFunctionModel functionModelWithName:@"崩溃记录" imageName:@"icon_home_crash" des:@"崩溃日志记录"];
    crash.plugin = [[YCCrashPlugin alloc] init];

    YCAssistiveFunctionModel *appInfo = [YCAssistiveFunctionModel functionModelWithName:@"app信息" imageName:@"icon_home_appinfo" des:@""];
    appInfo.plugin = [[YCAppInfoPlugin alloc] init];
    
    YCAssistiveFunctionViewModel *viewModel = [YCAssistiveFunctionViewModel viewModelWithTitle:@"常用功能" models:@[switcher,http,logger,crash,appInfo]];
    return viewModel;
}

- (YCAssistiveFunctionViewModel *)performanceDetectionFunctions {
    
    YCAssistiveFunctionModel *performance = [YCAssistiveFunctionModel functionModelWithName:@"卡顿检测" imageName:@"icon_home_ framerate" des:@""];
    
    YCAssistiveFunctionModel *cpu = [YCAssistiveFunctionModel functionModelWithName:@"cpu检测" imageName:@"icon_home_cpu" des:@""];
    
    YCAssistiveFunctionModel *memory = [YCAssistiveFunctionModel functionModelWithName:@"内存检测" imageName:@"icon_home_memory" des:@""];
    
    YCAssistiveFunctionModel *leak = [YCAssistiveFunctionModel functionModelWithName:@"泄漏检测" imageName:@"icon_home_leak" des:@""];
    leak.plugin = [[YCMemoryLeaksPlugin alloc] init];
    
    YCAssistiveFunctionModel *datu = [YCAssistiveFunctionModel functionModelWithName:@"大图检测" imageName:@"icon_home_datu" des:@""];
    datu.plugin = [[YCLargeImagePlugin alloc] init];
    
    YCAssistiveFunctionViewModel *viewModel = [YCAssistiveFunctionViewModel viewModelWithTitle:@"性能检测" models:@[performance,cpu,memory,leak,datu]];
    return viewModel;
}

- (YCAssistiveFunctionViewModel *)visualSenseFunctions {
    
    YCAssistiveFunctionModel *color = [YCAssistiveFunctionModel functionModelWithName:@"颜色吸取" imageName:@"icon_home_colorsucker" des:@""];
    color.plugin = [[YCColorSnapPlugin alloc] init];
    
//    YCAssistiveFunctionModel *hierarchy = [YCAssistiveFunctionModel functionModelWithName:@"页面层级" imageName:@"icon_home_hierarchy" des:@""];

    YCAssistiveFunctionViewModel *viewModel = [YCAssistiveFunctionViewModel viewModelWithTitle:@"视觉工具" models:@[color]];
    return viewModel;
}

@end
