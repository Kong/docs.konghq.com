---
title: Kong Gateway
breadcrumb: 概要
subtitle: ハイブリッドおよびマルチクラウド向けに構築されたAPIゲートウェイ、マイクロサービスおよび分散アーキテクチャに最適化されています
description: Kong Gatewayは、軽量で高速、柔軟なクラウドネイティブのAPIゲートウェイです。Kongはリバースプロキシであり、リクエストの管理、設定、およびルーティングを行います
konnect_cta_card: true
---

<blockquote class="note">
  <p><strong>{{ site.konnect_product_name }}を使用して5分未満でゲートウェイをセットアップ:</strong></p>
  <p>
    <a href="/konnect/">{{ site.konnect_product_name }}</a>は、モダンなアプリケーションをより良く、より速く、より安全に構築できるAPIライフサイクル管理プラットフォームです。
  </p>
  <p><a href="https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=install-gateway" class="no-link-icon">無料で開始 &rarr;</a></p>
</blockquote>

## はじめ方

<div class="docs-grid-install max-3">

  <a href="/konnect/getting-started/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand small" src="/assets/images/icons/kong-gradient.svg" alt="">
    <div class="install-text">Konnectで開始 <br> <span class="badge recommended"></span></div>
  </a>

  <a href="/gateway/{{page.release}}/get-started/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand small" src="/assets/images/icons/third-party/docker.svg" alt="">
    <div class="install-text">Dockerでローカルで開始</div>
  </a>

  <a href="/gateway/{{page.release}}/install/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand small" src="/assets/images/icons/documentation/icn-deployment-color.svg" alt="">
    <div class="install-text">プラットフォームにインストール</div>
  </a>
</div>

<div class="docs-grid-install docs-grid-install__bottom max-2">
  <a href="/hub/" class="docs-grid-install-block docs-grid-install-block__bottom">
    <img class="install-icon no-image-expand small" src="/assets/images/icons/documentation/icn-api-plugins-color.svg" alt="">
    <div class="install-block-column">
      <div class="install-text">Kongプラグインハブ</div>
      <div class="install-description">強力なプラグインでゲートウェイを拡張</div>
    </div>
  </a>

  <a href="/gateway/{{page.release}}/admin-api/" class="docs-grid-install-block docs-grid-install-block__bottom">
    <img class="install-icon no-image-expand small" src="/assets/images/icons/documentation/icn-admin-api-color.svg" alt="">
    <div class="install-block-column">
      <div class="install-text">APIリファレンスドキュメント</div>
      <div class="install-description">管理目的のための内部REST APIをセットアップ</div>
    </div>
  </a>
</div>

{{site.base_gateway}}でできることの詳細については、[機能](#features)を参照してください。

## {{ site.base_gateway }} の紹介

{{site.base_gateway}}は、軽量で高速、柔軟なクラウドネイティブのAPIゲートウェイです。APIゲートウェイはリバースプロキシであり、APIへのリクエストを管理、設定、およびルーティングすることができます。

{{site.base_gateway}}は、RESTful APIの前で実行され、モジュールとプラグインを介して拡張できます。分散型アーキテクチャ、ハイブリッドクラウド、マルチクラウドの展開に対応しています。

{{site.base_gateway}}を使用すると、ユーザーは以下のことができます:

* ワークフローの自動化とモダンなGitOpsの実践
* アプリケーション/サービスの分散化とマイクロサービスへの移行
* 繁栄するAPI開発者エコシステムの構築
* API関連の異常および脅威を積極的に特定
* API/サービスをセキュアに管理し、組織全体でAPIの可視性を向上させる

<blockquote class="note no-icon" id="nurture-signup">
  <p>追加のヘルプをお探しですか？無料のトレーニングや厳選されたコンテンツを提供しています：</p>
  <form action="https://go.konghq.com/l/392112/2022-09-19/cfr97r" method="post">
    <input class="button" name="email" placeholder="you@yourcompany.com" />
    <button class="button" type="submit">今すぐサインアップ</button>
  </form>
</blockquote>

## {{site.base_gateway}} の拡張

{{site.base_gateway}}はNginxで実行されるLuaアプリケーションです。{{site.base_gateway}}は、[OpenResty](https://openresty.org/)と一緒に配布されます。これは、[lua-nginx-module](https://github.com/openresty/lua-nginx-module)を拡張するモジュールのバンドルです。

これにより、プラグインが実行時に有効にされ、実行されるモジュラーなアーキテクチャが可能になります。{{site.base_gateway}}は、データベースの抽象化、ルーティング、およびプラグイン管理を実装しています。プラグインは別々のコードベースに存在し、数行のコードでリクエストライフサイクルのどこにでも注入できます。

Kongは、[プラグイン](#kong-gateway-plugins)を多数提供しており、ゲートウェイの展開で使用できます。また、独自のカスタムプラグインを作成することもできます。詳細については、[プラグイン開発ガイド](/gateway/{{page.release}}/plugin-development)、[PDKリファレンス](/gateway/{{page.release}}/plugin-development/pdk/)、および他の言語でプラグインを作成するためのガイド（[JavaScript](/gateway/{{page.release}}/plugin-development/pluginserver/javascript)、[Go](/gateway/{{page.release}}/plugin-development/pluginserver/go)、および[Python](/gateway/{{page.release}}/plugin-development/pluginserver/python/)）を参照してください。

## パッケージとモード

{{site.base_gateway}}の展開には、{{ site.konnect_saas }}で管理される方法と自己管理される方法の2つの方法があります。初めて{{site.base_gateway}}を試す場合は、[{{ site.konnect_saas }}](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=gateway-mode-overview)から始めることをお勧めします。

### {{site.konnect_short_name}}

{{site.konnect_short_name}}は、{{site.base_gateway}}を開始する最も簡単な方法を提供します。グローバルなコントロールプレーンはKongによってクラウドでホストされ、個々のデータプレーンノードは、お好みのネットワーク環境で管理されます。

{{site.konnect_short_name}}には2つの料金プランがあります:
* **プラス**: 自己サービスのペイアズユーゴーモデルで、組織が使用するサービスのみを支払う柔軟性があります。
* **エンタープライズ**: エンタープライズサブスクリプションでは、{{ site.konnect_saas }}スイート全体にアクセスできます:
  * 24時間365日の技術サポート
  * 環境に合わせた目的に特化したソリューションを作成するためのプロフェッショナルサービス

詳細については、[価格ページ](https://konghq.com/pricing)を参照してください。

![{{site.base_gateway}} の{{site.konnect_short_name}}での紹介](/assets/images/products/konnect/gateway-manager/konnect-control-planes-example.png)
> _図 1: {{site.base_gateway}} データプレーンが {{site.konnect_short_name}} コントロールプレーンに接続される概念図。_
> <br>
> _APIクライアントからのリクエストがゲートウェイのデータプレーンに流れ、プロキシによって変更および管理され、コントロールプレーン構成に基づいて上流のサービスに転送されます。_

### 自己管理

{{site.base_gateway}}には、オープンソース（OSS）とエンタープライズの2つの異なるパッケージがあります。

**{{site.ce_product_name}}**: 基本的なAPIゲートウェイ機能とオープンソースプラグインを含むオープンソースパッケージです。オープンソースのゲートウェイをKongの [管理API](#kong-admin-api){% if_version gte:3.4.x %}、[Kong Managerオープンソース](/gateway/{{page.release}}/kong-manager-oss/)、{% endif_version %}または [宣言的構成](#deck) で管理できます。

**{{site.ee_product_name}}**（[フリーモードまたはエンタープライズモード](https://konghq.com/pricing)で利用可能）: 追加の機能を備えたKongのAPIゲートウェイです。
* <span class="badge free"></span> **フリーモード**では、このパッケージに[Kong Manager](#kong-manager)が追加されます。
* <span class="badge enterprise"></span> **エンタープライズ**サブスクリプションでは、以下が含まれます:
    {% if_version lte:3.4.x -%}
    * [Dev Portal](#kong-dev-portal)
    * [Vitals](#kong-vitals)
    {% endif_version -%}
    * [RBAC](/gateway/api/admin-ee/latest/#/rbac/get-rbac-users)
    * [エンタープライズプラグイン](/hub/)

{{site.ee_product_name}}をフリーモードまたはエンタープライズモードで管理するには、Kongの [管理API](#kong-admin-api)、[宣言的構成](#deck)、または [Kong Manager](#kong-manager) を使用します。

![{{site.base_gateway}} の紹介](/assets/images/products/gateway/kong-gateway-features.png)
> _図 2: {{site.base_gateway}} の主要機能。{{site.ce_product_name}} は基本機能を提供し、{{site.ee_product_name}} はオープンソースの基盤に高度なプロキシ機能を追加します。_
> <br>
> _APIクライアントからのリクエストがゲートウェイに流れ、ゲートウェイの構成に基づいてプロキシによって変更および管理され、上流のサービスに転送されます。_

## 機能

{% include_cached feature-table.html config=site.data.tables.features.gateway %}

### Kong Admin API

[Kong管理API](/gateway/{{page.release}}/admin-api)は、サービス、ルート、プラグイン、コンシューマなどのゲートウェイエンティティの管理と構成のためのRESTfulインターフェースを提供します。ゲートウェイで実行できるすべてのタスクを、Kong管理APIを使用して自動化できます。

### Kong Manager
{:.badge .free}

{:.note}
> **注意**: 伝統的なモードでKongを実行している場合、トラフィックの増加によりKongプロキシのパフォーマンスに問題が発生する可能性があります。
> 大量のエンティティをサーバーサイドでソートおよびフィルタリングすると、Kong CPとデータベースの両方でCPU使用率が増加します。

[Kong Manager](/gateway/{{page.release}}/kong-manager/)は、{{site.base_gateway}}のグラフィカルユーザーインターフェース（GUI）です。Kong Managerは、{{site.base_gateway}}を管理および制御するためにKong管理APIを内部で使用します。

Kong Managerで以下のことができます:

* 新しいルートやサービスの作成
* 数回のクリックでプラグインの有効化または無効化
* チーム、サービス、プラグイン管理などを自由にグループ化

{% if_version lte:3.4.x -%}
* パフォーマンスの監視: 直感的でカスタマイズ可能なダッシュボードを使用して、クラスタ全体、ワークスペースレベル、またはオブジェクトレベルのヘルスを可視化
{% endif_version %}

{% if_version lte:3.4.x %}
### Kong Dev Portal
{:.badge .enterprise}

[Kong Dev Portal](/gateway/{{page.release}}/kong-enterprise/dev-portal/)は、新しい開発者のオンボーディングおよびAPIドキュメントの生成、カスタムページの作成、APIバージョンの管理、開発者アクセスのセキュリティ確保に使用されます。

### Kong Vitals
{:.badge .enterprise}

[Kong Vitals](/gateway/{{page.release}}/kong-enterprise/analytics/)は、{{site.base_gateway}}ノードのヘルスとパフォーマンスに関する有用なメトリクス、およびプロキシされたAPIの使用状況に関するメトリクスを提供します。リアルタイムで異常を特定し、APIアナリティクスを使用してAPIとゲートウェイのパフォーマンスおよび主要な統計情報を確認できます。Kong VitalsはKong Manager UIの一部です。
{% endif_version %}

### Kubernetes

{{site.base_gateway}}は、カスタム[イングレスコントローラ](/kubernetes-ingress-controller/)、Helmチャート、およびオペレータと共にKubernetes上でネイティブに実行できます。Kubernetesのイングレスコントローラは、Kubernetesクラスタで実行されるアプリケーション（例: デプロイメント、レプリカセット）からのトラフィックを、クラスタの外部で実行されるクライアントアプリケーションに公開するプロキシです。イングレスコントローラの目的は、Kubernetesクラスタへのすべての着信トラフィックに対する単一の制御点を提供することです。

### {{site.base_gateway}}プラグイン

[{{site.base_gateway}}プラグイン](/hub/)は、APIおよびマイクロサービスをよりよく管理するための高度な機能を提供します。{{site.base_gateway}}プラグインを有効にすることで、認証、レート制限、変換などの機能を簡単に利用できます。これにより、最大限の制御が可能になり、不必要なオーバーヘッドが最小限に抑えられます。Kong Managerまたは管理APIを介して{{site.base_gateway}}プラグインを有効にしてください。

## ツール
Kongは、{{site.base_gateway}}と共に使用できるAPIライフサイクル管理ツールも提供しています。

### Insomnia

[Insomnia](https://docs.insomnia.rest) は、すべてのRESTおよびGraphQLサービス向けのスペックファーストの開発を可能にします。Insomniaを使用すると、組織は自動化されたテスト、直接のGit同期、すべてのレスポンスタイプの検査を使用して、デザインおよびテストワークフローを加速させることができます。どんな規模のチームでも、Insomniaを使用して開発速度を向上させ、展開リスクを減らし、コラボレーションを増やすことができます。

### decK
[decK](/deck/) は、{{site.base_gateway}}の構成を宣言的な方法で管理するのに役立ちます。これは、開発者が {{site.base_gateway}} や {{site.konnect_short_name}} の望ましい状態を定義し、サービス、ルート、プラグインなどを実行せずに decK に処理させることを意味します。手動でKong管理APIを実行する必要はありません。

## {{site.base_gateway}}で始める

[{{site.base_gateway}}のダウンロードとインストール](/gateway/{{page.release}}/install/) を行います。試してみるには、オープンソースパッケージを選択するか、または {{site.ee_product_name}} をフリーモードで実行し、Kong Manager も試してみることができます。

インストール後、[クイックスタートガイド](/gateway/{{page.release}}/get-started/) を参照してください。

### {{site.konnect_short_name}} で試す

[{{site.konnect_product_name}}](/konnect/) を使用すると、{{site.base_gateway}} インスタンスを管理できます。このセットアップでは、Kongがコントロールプレーンをホストし、データプレーンを自分でホストします。

ゲートウェイのエンタープライズ機能を試すいくつかの方法があります:

- [{{site.konnect_product_name}}に登録](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=gateway-overview)します。
- [Kong Academy](site.links.learn)でラーニングラボをチェックします。
- ローカルでエンタープライズ機能を評価したい場合は、[デモをリクエスト](https://konghq.com/get-started/#request-demo)して、Kongの担当者が詳細を提供します。

## サポート方針
Kongは、製品のバージョン管理に構造化されたアプローチを採用しています。

{{site.ee_product_name}}と{{site.mesh_product_name}}の最新バージョンサポート情報については、[バージョンサポートポリシー](/gateway/{{page.release}}/support-policy/)を参照してください。
