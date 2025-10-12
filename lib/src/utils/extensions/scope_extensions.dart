// 功能说明：
// | 功能             | Kotlin   | Dart 对应            | 说明                   |
// |------------------|----------|---------------------|------------------------|
// | 临时作用域/null安全 | let      | ?.let / let()       | 安全访问对象属性         |
// | 执行逻辑块并返回结果 | run      | run() / IIFE        | 执行逻辑块并返回结果      |
// | 调试/副作用        | also     | also()              | 打印日志，不改变值        |
// | 初始化链           | apply    | apply() / ..操作符   | 修改对象属性并返回自身     |
extension ScopeExtensions<T> on T {
  R let<R>(R Function(T it) block) => block(this);
  R run<R>(R Function(T it) block) => block(this);
  T also(void Function(T it) block) {
    block(this);
    return this;
  }

  T apply(void Function(T it) block) {
    block(this);
    return this;
  }
}
