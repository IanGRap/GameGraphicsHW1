Shader "Custom/ToonShader" {
	Properties{
		_Color("Tint", Color) = (0, 0, 0, 1)
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader{
			Tags{ "RenderType" = "Opaque" "Queue" = "Geometry"}

			CGPROGRAM

			#pragma surface surf Custom fullforwardshadows
			#pragma target 3.0

			sampler2D _MainTex;
			fixed4 _Color;

			struct Input {
				float2 uv_MainTex;
			};

			void surf(Input i, inout SurfaceOutput o) {
				fixed4 col = tex2D(_MainTex, i.uv_MainTex);
				col *= _Color;
				o.Albedo = col.rgb;
			}

			float4 LightingCustom(SurfaceOutput s, float3 lightDir, float atten) 
			{
				return 0;
			}

			ENDCG
		}
}
